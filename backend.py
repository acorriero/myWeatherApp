import requests


API_KEY = "c1ec53f4fbda9ce1a104640d078182c2"


def get_data(place, days=None, type=None):

    url = f"http://api.openweathermap.org/data/2.5/forecast?q={place}&appid={API_KEY}"
    response = requests.get(url)
    data = response.json()

    filtered_data = data["list"]
    nr_values = 8 * days
    filtered_data = filtered_data[:nr_values]

    if type == "Temperature":
        filtered_data = [dict["main"]["temp"] for dict in filtered_data]
    
    if type == "Sky":
        filtered_data = [dict["weather"][0]["main"] for dict in filtered_data]
    
    return filtered_data


if __name__ == "__main__":
    print(get_data(place="Tokyo", days=3, type="Temperature"))