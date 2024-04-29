from rest_framework.decorators import api_view
from rest_framework.response import Response
from .serializers import *
from rest_framework import status
from rest_framework.authtoken.models import Token
from django.contrib.auth.models import User
from core.models import *

@api_view(['POST'])
def login(request):
    try:
        user = User.objects.get(username=request.data.get('username'))
        person = user.person  # Assuming person is the related name for the OneToOneField
    except User.DoesNotExist:
        return Response({"detail": "Invalid credentials"}, status=status.HTTP_404_NOT_FOUND)

    if not user.check_password(request.data.get('password')):
        return Response({"detail": "Invalid credentials"}, status=status.HTTP_401_UNAUTHORIZED)

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




from rest_framework.decorators import authentication_classes,permission_classes
from rest_framework.authentication import SessionAuthentication, TokenAuthentication
from rest_framework.permissions import IsAuthenticated



@api_view(['GET'])
@authentication_classes([SessionAuthentication, TokenAuthentication])
@permission_classes([IsAuthenticated])
def test_token(request):
    return Response("passed for {}".format(request.user.username))
