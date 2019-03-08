public with sharing class TemperatureConverter {

    public static Decimal fahrenheitToCelsius(String fh){
        try {
            Decimal temp = (Decimal.valueOf(fh) -32)*5/9;
            return temp.setScale(2);
           
        } catch (Exception e) {
           System.debug(e);
           return null;
        }
    }
}