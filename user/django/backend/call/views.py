from django.shortcuts import render
from django.http import JsonResponse
from geopy.distance import geodesic



def getUserLocationn(request):
    User_id = request.POST.get('id')
    user = AppUser.objects.get(pk=User_id)
    user.latitude = request.POST.get('latitude')
    user.longitude = request.POST.get('ilongituded')
    user.save()
    dispatcher = get_closest_dispatcher(user.latitude,user.longitude)
    if dispatcher is not None:
        return JsonResponse({'dispatcher_id': dispatcher.pk})


def get_closest_dispatcher(user_latitude, user_longitude):
    # Get all dispatchers
    all_dispatchers = Dispatcher.objects.all()

    # Calculate distances between user and dispatchers
    distances = []
    for dispatcher in all_dispatchers:
        dispatcher_latitude = dispatcher.latitude
        dispatcher_longitude = dispatcher.longitude
        if dispatcher_latitude is not None and dispatcher_longitude is not None:
            dispatcher_location = (dispatcher_latitude, dispatcher_longitude)
            user_location = (user_latitude, user_longitude)
            distance = geodesic(dispatcher_location, user_location).kilometers
            distances.append((dispatcher, distance))

    # Sort dispatchers by distance
    sorted_dispatchers = sorted(distances, key=lambda x: x[1])

    # Find the closest available dispatcher
    for dispatcher, distance in sorted_dispatchers:
        if dispatcher.is_available:
            return dispatcher

    # If no available dispatcher is found
    return None



def join_call(request):
    dispatcher_id = request.POST.get('dispatcher_id')
    # Mark dispatcher as unavailable when they join a call
    dispatcher = Dispatcher.objects.get(pk=dispatcher_id)
    dispatcher.is_available = False
    dispatcher.save()
    # Other logic for joining the call

    return JsonResponse({'success': True})

def end_call(request):
    dispatcher_id = request.POST.get('dispatcher_id')
    # Mark dispatcher as available when they end the call
    dispatcher = Dispatcher.objects.get(pk=dispatcher_id)
    dispatcher.is_available = True
    dispatcher.save()
    # Other logic for ending the call

    return JsonResponse({'success': True})