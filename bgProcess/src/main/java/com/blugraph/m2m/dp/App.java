package com.blugraph.m2m.dp;

import java.util.Calendar;
import java.util.GregorianCalendar;
import java.util.List;
import java.util.TimeZone;


/**
 * The main app, starting point.
 */
public class App {

    private static int WAIT_TIME = 5*60*1000; // 5mts
    private static final int WORK_HRS_START_HR = 7;
    //private static int WAIT_TIME = 10; // 5mts
    private static long last_processing_time = 0;
    private volatile boolean continueDp = true;

    public static void main(String[] args) {
        System.out.println("Inside App!");
            
        // At the start of program, set a limit to fetch history sensor data.
        Calendar now = new GregorianCalendar();
        long last_processing_time = now.getTimeInMillis() - (30*60*1000); 
        App localApp = new App();
    }

    /*
    * Constructor. 
    */
    public App() { //throws InterruptedException
        QueryDataLocal queryIf = new QueryDataLocal();
        ProcessData processData = new ProcessData();

        while (continueDp) {
            try {
                Thread.sleep(WAIT_TIME);
            } catch (InterruptedException ex) {
                Thread.currentThread().interrupt();
                //throw ex;
            }

            Calendar now = new GregorianCalendar();
            long currentServerTime = now.getTimeInMillis(); // System.currentTimeMillis() 1434095700.000
            //System.out.println(currentServerTime);
            int hourNow = now.get(Calendar.HOUR_OF_DAY);
            int minuteNow = now.get(Calendar.MINUTE);

            // TODO: No processing required after 7pm, till 7am.

            // Consider only the 10 minute window just before the start of an hour.
            if(minuteNow < 50) {
                continue;
            }

            System.out.println("App: Within 10mts window.");
            // Avoid repeated processing within the 10 minute window. Wait for 30 mts after last processing.
            if( (currentServerTime - last_processing_time) < (30*60*1000)) {
                continue;
            }

            System.out.println("App: First time within the 10mts window.");

            // All conditions satisfied, process the window of data.
            List<StationInfo> stationInfoList = queryIf.getCurrentStations();

            for (StationInfo station : stationInfoList) {

                long startTime = last_processing_time;
                long endTime = currentServerTime;

                // Get data for approximate window of one hour.
                List<DataSample> dataSample1Hr = queryIf.getDataForStation(station, SensorTypes.SoundNoise, startTime, endTime);
                // If no samples for the hour, don't update any values.
                // TODO: review this condition.
                if(dataSample1Hr.size() == 0) 
                    continue;
                // start time is 7am of the day.
                Calendar workStartTime = Calendar.getInstance();
                workStartTime.set(Calendar.MILLISECOND, 0);
                workStartTime.set(Calendar.SECOND, 0);
                workStartTime.set(Calendar.MINUTE, 0);
                workStartTime.set(Calendar.HOUR_OF_DAY, WORK_HRS_START_HR);  // Today, 7am.
/*
                if (workStartTime.before(Calendar.getInstance())) {
                    workStartTime.add(Calendar.HOUR, 1);
                }
*/
                long workStartTimeMillis =  workStartTime.getTimeInMillis(); //1434092400

                System.out.println("App: Current time in millis =" + endTime);

                List<DataSample> dataHourlySample = queryIf.getHourlyDataForStation(station, SensorTypes.SoundNoise, workStartTimeMillis, endTime);

                // process the new list of 1hr data.
                //boolean result = processData.process4Station(startTime, hourNow, dataSample1Hr, dataHourlySample);
                List<Double> leq1hrResult = processData.process4Station(hourNow, dataSample1Hr, dataHourlySample);
                //boolean result = processData.processAllStations(dataSample1Hr);
                //List<Double> leq1hrResult = processData.getResult(SensorTypes.SoundNoise);

                if(leq1hrResult != null) {
                    System.out.println("App: Send SMS, update DB.");
                    // Send SMS message, if some threshold exceeded. Runs in separate thread.
                    // TODO: handle result.
                    //SendSMS.INSTANCE.sendMessage(leq1hrResult);
                    queryIf.updateResultsToDb(station, SensorTypes.SoundNoise, leq1hrResult);
                }

                // Save the processing moment.
                last_processing_time = currentServerTime;
            }
        }
    }
}
