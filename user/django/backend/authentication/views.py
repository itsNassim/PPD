from rest_framework.decorators import api_view
from rest_framework.response import Response
from .serializers import *
from rest_framework import status
from rest_framework.authtoken.models import Token
from django.contrib.auth.models import User
from core.models import *

from rest_framework.decorators import authentication_classes,permission_classes
from rest_framework.authentication import SessionAuthentication, TokenAuthentication
from rest_framework.permissions import IsAuthenticated


from django.core.mail import send_mail
from django.utils.crypto import get_random_string

#login sing up funtions

@api_view(['POST'])
def login(request):
    try:
        user = User.objects.get(username=request.data.get('username'))
        person = user.person  # Assuming person is the related name for the OneToOneField
    except User.DoesNotExist:
        return Response({"Invalid Username"}, status=status.HTTP_404_NOT_FOUND)

    if not user.check_password(request.data.get('password')):
        return Response({"Invalid Password"}, status=status.HTTP_401_UNAUTHORIZED)

    token, created = Token.objects.get_or_create(user=user)
    serializer = PersonSerializer(instance=person)
    return Response({"token": token.key, "person": serializer.data})

@api_view(['POST'])
def loginDispatcher(request):
    try:
        user = User.objects.get(username=request.data.get('username'))
        dispatcher = user.dispatcher  # Assuming person is the related name for the OneToOneField
    except User.DoesNotExist:
        return Response({"detail": "Invalid credentials"}, status=status.HTTP_404_NOT_FOUND)

    if not user.check_password(request.data.get('password')):
        return Response({"detail": "Invalid credentials"}, status=status.HTTP_401_UNAUTHORIZED)

    token, created = Token.objects.get_or_create(user=user)
    serializer = PersonSerializer(instance=dispatcher)
    return Response({"token": token.key, "dispatcher": serializer.data})

@api_view(['POST'])
def signup(request):
    serializer = PersonSerializer(data=request.data)
    print("enter")
    if serializer.is_valid():
        user_data = {
            'username': request.data.get('username'),
            'password': request.data.get('password'),
            'email': request.data.get('email'),
        }
        user_serializer = UserSerializer(data=user_data)
        if user_serializer.is_valid():
            user = user_serializer.save()
            user.set_password(request.data['password']) #helps us to save the password in hash format to make it more safe
            user.save()
            person = serializer.save(user=user)
            
            # Create token for the user
            token, created = Token.objects.get_or_create(user=user)
            
            return Response({"token": token.key, "person": serializer.data})
    return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)


@api_view(['POST'])
def signup2(request):
    # Retrieve the user by username
    try:
        user = User.objects.get(username=request.data.get('username'))
    except User.DoesNotExist:
        return Response({"error": "User with this username does not exist."}, status=status.HTTP_404_NOT_FOUND)

    # Retrieve the associated person
    person = user.person

    # Prepare data for AppUser
    app_user_data = {
        'person': person.pk,
        'blood_group': request.data.get('blood_group')
    }

    # Initialize and validate the serializer
    serializer = AppUserSerializer(data=app_user_data)
    if serializer.is_valid():
        # Save the AppUser instance
        app_user_instance = serializer.save()

        # Generate or retrieve the token
        token, created = Token.objects.get_or_create(user=user)

        # Return the response
        response_data = {
            "token": token.key,
            "AppUser": serializer.data
        }
        return Response(response_data)
    
    # If serializer is not valid, return errors
    return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)


#get info functions

@api_view(['GET'])
@permission_classes([IsAuthenticated])
def get_user_info(request):
    user = request.user
    serializer = UserSerializer(user)
    return Response(serializer.data)

@api_view(['GET'])
@permission_classes([IsAuthenticated])
def get_person_info(request):
    person = request.user.person  # Assuming there's a one-to-one relationship between User and Person
    serializer = PersonSerializer(person)
    return Response(serializer.data)


@api_view(['GET'])
@permission_classes([IsAuthenticated])
def get_appuser_info(request):
    appuser = request.user.person.appuser  # Assuming there's a one-to-one relationship between User and Person
    serializer = AppUserSerializer(appuser)
    return Response(serializer.data)


#diseases
#Add UserDiseases
@api_view(['POST'])
@permission_classes([IsAuthenticated])
def add_user_diseases(request):
    # Extract data from the request
    user_id = request.user.pk
    disease_id = request.data.get('disease')

    # Check if the disease exists
    try:
        disease = Disease.objects.get(pk=disease_id)
    except Disease.DoesNotExist:
        return Response({"error": "Invalid disease ID"}, status=status.HTTP_400_BAD_REQUEST)

    # Create user-disease data
    user_disease_data = {
        'user': user_id,
        'disease': disease_id,
    }

    # Serialize user-disease data
    serializer = UserDiseaseSerializer(data=user_disease_data)

    if serializer.is_valid():
        serializer.save()
        return Response(serializer.data, status=status.HTTP_201_CREATED)
    return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)
#get Disease
@api_view(['GET'])
def get_diseases(request):
    diseases = Disease.objects.all()
    serializer = DiseaseSerializer(diseases, many=True)  # Note: Use 'many=True' for serializing multiple objects
    return Response(serializer.data)
#get UserDiseases
@api_view(['GET'])
@permission_classes([IsAuthenticated])
def get_user_diseases(request):
    
    user_diseases = UserDisease.objects.filter(user=request.user)
    
    disease_ids = user_diseases.values_list('disease_id', flat=True)
    
    diseases = Disease.objects.filter(pk__in=disease_ids)
    
    serializer = DiseaseSerializer(diseases, many=True)
    
    return Response(serializer.data)
#delete UserDisease
@api_view(['POST'])
@permission_classes([IsAuthenticated])
def delete_user_disease(request):
    try:
        # Get data from request
        user = request.user
        disease_id = request.data.get('disease_id')

        # Ensure disease_id is provided
        if not disease_id:
            return Response({"error": "Disease ID is required."}, status=400)

        # Find the user-disease instance to delete
        user_disease = UserDisease.objects.filter(user=user, disease=disease_id).first()

        if user_disease:
            user_disease.delete()
            return Response({"message": "User-disease instance deleted successfully."}, status=204)
        else:
            return Response({"error": "User-disease instance not found."}, status=404)

    except Exception as e:
        return Response({"error": str(e)}, status=500)

    except Exception as e:
        return Response({"error": str(e)}, status=500)

 
#modify info functions

@api_view(['POST'])
@permission_classes([IsAuthenticated])
def update_user_info(request):
    try:
        user = request.user
        user_data = {
            'username': user.username,
            'password': user.password,
            'email': request.data.get('email'),
        }
        serializer = UserSerializer(user, data=user_data)
        if serializer.is_valid():
            serializer.save()
            return Response(serializer.data)
        else:
            return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)
    except Exception as e:
        return Response({'error': str(e)}, status=status.HTTP_500_INTERNAL_SERVER_ERROR)

@api_view(['POST'])
@permission_classes([IsAuthenticated])
def update_person_info(request):
    try:
        user = request.user
        person = user.person
        person_data = {
            'user': user.pk,
            'first_name': person.first_name,
            'last_name':person.last_name,
            'phone_number': request.data.get('phone_number'),
            'gender':person.gender,
            'date_of_birth':person.date_of_birth,
            'address':request.data.get('address'),
            'role': 'User',
        }
        serializer = PersonSerializer(person, data=person_data)
        if serializer.is_valid():
            serializer.save()
            return Response(serializer.data)
        else:
            return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)
    except Exception as e:
        return Response({'error': str(e)}, status=status.HTTP_500_INTERNAL_SERVER_ERROR)


@api_view(['POST'])
@permission_classes([IsAuthenticated])
def update_appuser_info(request):
    try:
        user = request.user
        person = user.person
        appuser = person.appuser
        appuser_data = {
            'person': person.pk,
            'blood_group': request.data.get('blood_group'),
            'number_of_warnings':appuser.number_of_warnings,
            'number_of_bans': appuser.number_of_bans,
            'profile_pic':request.data.get('profile_pic'),
        }
        serializer = AppUserSerializer(appuser, data=appuser_data)
        if serializer.is_valid():
            serializer.save()
            return Response(serializer.data)
        else:
            return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)
    except Exception as e:
        return Response({'error': str(e)}, status=status.HTTP_500_INTERNAL_SERVER_ERROR)


#Delete account 
@api_view(['POST'])
@permission_classes([IsAuthenticated])
def deleteAccount(request):
    user = request.user
    user.delete()
    return Response({"message": "User-disease instance deleted successfully."}, status=204)


#password rest
@api_view(['POST'])
def request_password_recovery(request):
    email = request.data.get('email')
    try:
        user = User.objects.get(email=email)
        username = user.username
        confirmation_code = get_random_string(length=6)
        PasswordReset.objects.create(user=user, confirmation_code=confirmation_code)
        # Send email with confirmation code
        send_mail(
            'Password Reset Confirmation',
            f'Dear {username},\n\n'
            f'We received a request to reset your password. To proceed with the password reset process, please use the following confirmation code:\n\n'
            f'Confirmation Code: {confirmation_code}\n\n'
            f'If you did not request this password reset, please disregard this email. Your account security is important to us.\n\n'
            f'Thank you,\n'
            f'AidNow Team',
            'ntouati620@gmail.com',
            [email],
            fail_silently=False,
        )
        return Response({'message': 'Recovery email sent successfully'})
    except User.DoesNotExist:
        return Response({'error': 'User not found'}, status=404)

#resnd code
@api_view(['POST'])
def resend(request):
    email = request.data.get('email')
    try:
        user = User.objects.get(email=email)
        username = user.username
        confirmation_code = get_random_string(length=6)
        password_reset_instance = PasswordReset.objects.filter(user=user).first()
        if password_reset_instance:
            password_reset_instance.delete()
        PasswordReset.objects.create(user=user, confirmation_code=confirmation_code)
        # Send email with confirmation code
        send_mail(
            'Password Reset Confirmation',
            f'Dear {username},\n\n'
            f'We received a request to reset your password. To proceed with the password reset process, please use the following confirmation code:\n\n'
            f'Confirmation Code: {confirmation_code}\n\n'
            f'If you did not request this password reset, please disregard this email. Your account security is important to us.\n\n'
            f'Thank you,\n'
            f'AidNow Team',
            'ntouati620@gmail.com',
            [email],
            fail_silently=False,
        )
        return Response({'message': 'Recovery email sent successfully'})
    except User.DoesNotExist:
        return Response({'error': 'User not found'}, status=404)

#confirm code
@api_view(['POST'])
def confirm_password_reset(request):
    confirmation_code = request.data.get('confirmation_code')

    try:
        password_reset = PasswordReset.objects.get(confirmation_code=confirmation_code)

        password_reset.delete()

        return Response({'message': 'Password reset confirmed'})
    except PasswordReset.DoesNotExist:
        return Response({'error': 'Invalid confirmation code'}, status=400)


@api_view(['POST'])
def change_password(request):
        data = request.POST
        email = data.get('email')
        new_password = data.get('new_password')

        # Check if the email exists in the database
        try:
            user = User.objects.get(email=email)
        except User.DoesNotExist:
            return Response({'message': 'User not found'}, status=404)
        
        try:
            # Set the new password for the user
            user.set_password(new_password)
            user.save()
            return Response({'message': 'Password reset successful'})
        except User.DoesNotExist:
            return Response({'error': 'Invalid password'}, status=400)