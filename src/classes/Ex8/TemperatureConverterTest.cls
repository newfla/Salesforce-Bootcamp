@isTest
public with sharing class TemperatureConverterTest {
    
    @isTest
        static void checkGoodValues(){
            System.assertEquals(21.11, TemperatureConverter.fahrenheitToCelsius('70'));
            System.assertEquals(0, TemperatureConverter.fahrenheitToCelsius('32'));
            System.assertEquals(32, TemperatureConverter.fahrenheitToCelsius('0'));
            System.assertEquals(100, TemperatureConverter.fahrenheitToCelsius('212'));
            System.assertEquals(-23.33, TemperatureConverter.fahrenheitToCelsius('-10'));
        }

        
    @isTest
        static void checkWrongValues(){
            System.assertEquals(null, TemperatureConverter.fahrenheitToCelsius(''));
            System.assertEquals(null, TemperatureConverter.fahrenheitToCelsius(null));
            System.assertEquals(null, TemperatureConverter.fahrenheitToCelsius('Hakuna matata'));
        }
}