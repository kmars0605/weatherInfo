import Foundation
@testable import WeatherInfo

extension OneCall {
    static var exampleJSON: String {
        return """
            {
                "lat": 35.6776,
                "lon": 139.7651,
                "timezone": "Asia/Tokyo",
                "timezone_offset": 32400,
                "current": {
                    "dt": 1615444220,
                    "sunrise": 1615409876,
                    "sunset": 1615452261,
                    "temp": 15.3,
                    "feels_like": 10.92,
                    "pressure": 1026,
                    "humidity": 50,
                    "dew_point": 4.95,
                    "uvi": 0.67,
                    "clouds": 20,
                    "visibility": 10000,
                    "wind_speed": 4.63,
                    "wind_deg": 160,
                    "weather": [
                    {
                    "id": 801,
                    "main": "Clouds",
                    "description": "few clouds",
                    "icon": "02d"
                    }
                    ]
                },
                "minutely": [
                {
                "dt": 1615444260,
                "precipitation": 0
                }
                ],
                "hourly": [
                {
                "dt": 1615442400,
                "temp": 15.3,
                "feels_like": 10.59,
                "pressure": 1026,
                "humidity": 50,
                "dew_point": 4.95,
                "uvi": 1.78,
                "clouds": 20,
                "visibility": 10000,
                "wind_speed": 5.1,
                "wind_deg": 190,
                "wind_gust": 5.62,
                "weather": [
                {
                "id": 801,
                "main": "Clouds",
                "description": "few clouds",
                "icon": "02d"
                }
                ],
                "pop": 0
                }
                ],
                "daily": [
                {
                "dt": 1615428000,
                "sunrise": 1615409876,
                "sunset": 1615452261,
                "temp": {
                "day": 10.74,
                "min": 7.9,
                "max": 15.3,
                "night": 13.48,
                "eve": 13.91,
                "morn": 8.07
                },
                "feels_like": {
                "day": 7.22,
                "night": 9.94,
                "eve": 7.87,
                "morn": 4.06
                },
                "pressure": 1028,
                "humidity": 34,
                "dew_point": -4.53,
                "wind_speed": 1.38,
                "wind_deg": 101,
                "weather": [
                {
                "id": 800,
                "main": "Clear",
                "description": "clear sky",
                "icon": "01d"
                }
                ],
                "clouds": 0,
                "pop": 0,
                "uvi": 5.2
                }
                ]
            }
            """
    }
}

extension Current {
    static var exampleJSON: String {
        return """
            {
                "dt": 1615444220,
                "sunrise": 1615409876,
                "sunset": 1615452261,
                "temp": 15.3,
                "feels_like": 10.92,
                "pressure": 1026,
                "humidity": 50,
                "dew_point": 4.95,
                "uvi": 0.67,
                "clouds": 20,
                "visibility": 10000,
                "wind_speed": 4.63,
                "wind_deg": 160,
                "weather": [
                {
                "id": 801,
                "main": "Clouds",
                "description": "few clouds",
                "icon": "02d"
                }
                ]
            }
            """
    }
}

extension Hourly {
    static var exampleJSON: String {
        return """
        [
           {
           "dt": 1615442400,
           "temp": 15.3,
           "feels_like": 10.59,
           "pressure": 1026,
           "humidity": 50,
           "dew_point": 4.95,
           "uvi": 1.78,
           "clouds": 20,
           "visibility": 10000,
           "wind_speed": 5.1,
           "wind_deg": 190,
           "wind_gust": 5.62,
           "weather": [
           {
           "id": 801,
           "main": "Clouds",
           "description": "few clouds",
           "icon": "02d"
           }
           ],
           "pop": 0
           }
        ]
        """
    }
}

extension Daily {
    static var exampleJSON: String {
        return """
            [
            {
            "dt": 1615428000,
            "sunrise": 1615409876,
            "sunset": 1615452261,
            "temp": {
            "day": 10.74,
            "min": 7.9,
            "max": 15.3,
            "night": 13.48,
            "eve": 13.91,
            "morn": 8.07
            },
            "feels_like": {
            "day": 7.22,
            "night": 9.94,
            "eve": 7.87,
            "morn": 4.06
            },
            "pressure": 1028,
            "humidity": 34,
            "dew_point": -4.53,
            "wind_speed": 1.38,
            "wind_deg": 101,
            "weather": [
            {
            "id": 800,
            "main": "Clear",
            "description": "clear sky",
            "icon": "01d"
            }
            ],
            "clouds": 0,
            "pop": 0,
            "uvi": 5.2
            }
            ]
            """
    }
}
