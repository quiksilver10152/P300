import javax.swing.*;
import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;
import java.util.stream.*;

//------------------------------------------------------------------------
//                       Global Variables & Instances
//------------------------------------------------------------------------

DataProcessing_User dataProcessing_user;
boolean drawEMG = false; //if true... toggles on EEG_Processing_User.draw and toggles off the headplot in Gui_Manager
boolean drawAccel = false;
boolean drawPulse = false;
boolean drawFFT = true;
boolean drawBionics = false;
boolean drawHead = true;


String oldCommand = "";
boolean hasGestured = false;

//------------------------------------------------------------------------
//                            Classes
//------------------------------------------------------------------------

class DataProcessing_User {
    private float fs_Hz;  //sample rate
    private int n_chan;
    private Timer timer;
    boolean switchesActive = false;
    
               
    
   
     
    Button leftConfig = new Button(3*(width/4) - 65,height/4 - 120,20,20,"\\/",fontInfo.buttonLabel_size);
    Button midConfig = new Button(3*(width/4) + 63,height/4 - 120,20,20,"\\/",fontInfo.buttonLabel_size);
    Button rightConfig = new Button(3*(width/4) + 190,height/4 - 120,20,20,"\\/",fontInfo.buttonLabel_size);

    //class constructor
    DataProcessing_User(int NCHAN, float sample_rate_Hz) {
      n_chan = NCHAN;
      fs_Hz = sample_rate_Hz;
    }
  
    //add some functions here...if you'd like
  
    //here is the processing routine called by the OpenBCI main program...update this with whatever you'd like to do
    public void process(float[][] data_newest_uV, //holds raw bio data that is new since the last call
      float[][] data_long_uV, //holds a longer piece of buffered EEG data, of same length as will be plotted on the screen
      float[][] data_forDisplay_uV, //this data has been filtered and is ready for plotting on the screen
      FFT[] fftData) {              //holds the FFT (frequency spectrum) of the latest data
  
      //for example, you could loop over each EEG channel to do some sort of time-domain processing
      //using the sample values that have already been filtered, as will be plotted on the display
      float EEG_value_uV;
      float[] auxVals = auxBuff[1].clone();
      auxCheck = auxCheck + auxBuff[0][0] + auxBuff[0][1] + auxBuff[0][2] + auxBuff[0][3] + auxBuff[0][4] + auxBuff[0][5] + auxBuff[0][6] + auxBuff[0][7];
      System.out.println(auxCheck);
      if ((int)auxCheck > 0){
           int divisor = 479001600; //Lehmur decoding of 12 digit permutation.
           int a = (int)auxBuff[0][0] + (int)auxBuff[0][1] + (int)auxBuff[0][2] + (int)auxBuff[0][3] + (int)auxBuff[0][4] + (int)auxBuff[0][5] + (int)auxBuff[0][6] + (int)auxBuff[0][7];
           int b = (int)auxBuff[1][0] + (int)auxBuff[1][1] + (int)auxBuff[1][2] + (int)auxBuff[1][3] + (int)auxBuff[1][4] + (int)auxBuff[1][5] + (int)auxBuff[1][6] + (int)auxBuff[1][7];
           int c = (int)auxBuff[2][0] + (int)auxBuff[2][1] + (int)auxBuff[2][2] + (int)auxBuff[2][3] + (int)auxBuff[2][4] + (int)auxBuff[2][5] + (int)auxBuff[2][6] + (int)auxBuff[2][7];
           d = a * 1000000 + b * 1000 + c;     
           for(int j = 0; j < 11; j++){
              integerToCode(d, 11-j);
             }
           codeToPermutation(lehmurCode);
            timer = new Timer(500, new ActionListener() {
             int count = 0;   
              @Override
                     public void actionPerformed(ActionEvent evt) {
                       JDialog dialog = new JDialog();          
                       dialog.setUndecorated(true);
                       JLabel label = new JLabel( new ImageIcon(labels[gridList[count]]));
                       dialog.add( label );
                       dialog.pack();
                       dialog.setVisible(true);
                       count++;
                      if (count == 12) {
                          timer.stop();
                      }
                  }    
              });
           timer.start(); 
           System.out.println(Arrays.toString(gridList));
           auxCheck = 0;
    }
  }
}
  void integerToCode(int randomInt, int permSize) {
          int multiplier = factorial(permSize);
          int digit = floor(randomInt / multiplier);
          d = randomInt % multiplier;
          lehmurCode[permSize] = digit;
          }
              
  void codeToPermutation(int[] code) {
          for (int j = 0; j < 12; j++){
           
             for(int i=11; i > code[j]; i--){
                   gridList[i] = gridList[i-1];
                 }
         
                 gridList[code[j]] = 12-j;
               }
             
      }
    
     int factorial(int n) {
        if (n <= 0) {
            return 1;
        } else {
            return n * factorial(n-1);
        }
    }

private static String[] createLabels(){
       String[] labels=new String[13];
       for (int i=0;i<13;i++){
           labels[i]=new String("C:/Users/GPZ1100/Desktop/Test/SpellerGrids/Grid" + i +".jpg");
          System.out.println(labels[i]);
       }
       return labels;
}
public static double[] convertFloatsToDoubles(float[] input)
{
    if (input == null)
    {
        return null; // Or throw an exception - your choice
    }
    double[] output = new double[input.length];
    for (int i = 0; i < input.length; i++)
    {
        output[i] = input[i];
    }
    return output;
}