using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Windows;
using System.Windows.Controls;
using System.Windows.Data;
using System.Windows.Documents;
using System.Windows.Input;
using System.Windows.Media;
using System.Windows.Media.Imaging;
using System.Windows.Navigation;
using System.Windows.Shapes;
using Microsoft.Kinect;
using System.Drawing;
using System.IO;
using AForge.Imaging;
using AForge.Imaging.Filters;
using AForge.Math;
using AForge.Math.Geometry;
using AForge;

namespace WpfApplication1
{
    /// <summary>
    /// Interaction logic for MainWindow.xaml
    /// </summary>
    public partial class MainWindow : Window
    {
        
        public MainWindow()
        {   
            InitializeComponent();
        }
        public byte[] pixelData;
        byte[] depth32;
        int colorIndex;
        BitmapSource BlobBitmapFeed;
        int slowdown = 0;
        int[] currentblobxpos = new int[] { 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 };
        int[] prevblobxpos = new int[] { 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 };
        string blobsfound = null;
        string prevblobsfound = null;
        int peopleinside = 0;
        int peopleinlobby = 0;
        int peopleoutside = 0;
        string dir = "Unknown";
        string currentpos = "";
        String prevposition = "";
        public byte[] pixelDatak2;
        byte[] depth32k2;
        int colorIndexk2;
        BitmapSource BlobBitmapFeedk2;
        int slowdownk2 = 0;
        int[] currentblobxposk2 = new int[] { 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 };
        int[] prevblobxposk2 = new int[] { 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 };
        string blobsfoundk2 = null;
        string prevblobsfoundk2 = null;
        int peopleinsidek2 = 0;
        int peopleinlobbyk2 = 0;
        int peopleoutsidek2 = 0;
        string dirk2 = "Unknown";
        string currentposk2 = "";
        String prevpositionk2 = "";
       
        //declare
        int previnsidek1 = 0, prevoutsidek1=0;
        int currentinsidek1, currentoutsidek1;
        int previnsidek2 = 0, prevoutsidek2 = 0;
        int currentinsidek2, currentoutsidek2;

        private void Window_Loaded(object sender, RoutedEventArgs e)
        {

            

            //kinect initialize start
            KinectSensor sensor1, sensor2;
            
            if (KinectSensor.KinectSensors.Count < 1)
            {
                MessageBox.Show("No device is connected with system!");
                this.Close();
            }

            else
            {
                //check for two sensor begins
                if (KinectSensor.KinectSensors.Count < 2)
                {

                    MessageBox.Show("Only one Kinect Decice is connected with system, You can use up to two kinect devices. Connect another device and restart the system to use two devices or Click OK to continue with one device !");
                    Statuslbl.Content = "Kinect 1: Counting";
                    sensor1 = KinectSensor.KinectSensors[0];
                    sensor1.Start();
                    sensor1.ColorStream.Enable(ColorImageFormat.RgbResolution640x480Fps30);
                    sensor1.DepthStream.Enable(DepthImageFormat.Resolution640x480Fps30);

                    //kinect initialize end

                    //capture frame events
                    sensor1.ColorFrameReady += new EventHandler<ColorImageFrameReadyEventArgs>(sensor1_ColorFrameReady);
                    sensor1.DepthFrameReady += new EventHandler<DepthImageFrameReadyEventArgs>(sensor1_DepthFrameReady);
                }
                //check for two sensors end

                else 
                {

                    sensor1 = KinectSensor.KinectSensors[0];
                    Statuslbl.Content = "Kinect 1: Counting";
                    sensor1.Start();
                    sensor1.ColorStream.Enable(ColorImageFormat.RgbResolution640x480Fps30);
                    sensor1.DepthStream.Enable(DepthImageFormat.Resolution640x480Fps30);

                    //kinect initialize end

                    //capture frame events
                    sensor1.ColorFrameReady += new EventHandler<ColorImageFrameReadyEventArgs>(sensor1_ColorFrameReady);
                    sensor1.DepthFrameReady += new EventHandler<DepthImageFrameReadyEventArgs>(sensor1_DepthFrameReady);

                    sensor2 = KinectSensor.KinectSensors[1];
                    Statuslblk2.Content = "Kinect 2: Counting";
                    sensor2.Start();
                    sensor2.ColorStream.Enable(ColorImageFormat.RgbResolution640x480Fps30);
                    sensor2.DepthStream.Enable(DepthImageFormat.Resolution640x480Fps30);

                    //kinect initialize end

                    //capture frame events
                    sensor2.ColorFrameReady += new EventHandler<ColorImageFrameReadyEventArgs>(sensor2_ColorFrameReady);
                    sensor2.DepthFrameReady += new EventHandler<DepthImageFrameReadyEventArgs>(sensor2_DepthFrameReady);
                
                }




            }

            }

        //Depth camera feed generator start Sensor 2
        void sensor2_DepthFrameReady(object sender, DepthImageFrameReadyEventArgs e)
        {
            
                using (DepthImageFrame depthimageFramek2 = e.OpenDepthImageFrame())
                {
                    if (depthimageFramek2 == null)
                    {
                        return;
                    }
                    if (slowdown > 6)
                    {
                    short[] pixelDatak2 = new short[depthimageFramek2.PixelDataLength];
                    int stridek2 = depthimageFramek2.Width * 2;
                    depthimageFramek2.CopyPixelDataTo(pixelDatak2);

                    depth32k2 = new byte[depthimageFramek2.PixelDataLength * 4];
                    this.GetColorPixelDataWithDistancek2(pixelDatak2);

                    deplthimageimgk2.Source = BlobBitmapFeedk2 = BitmapSource.Create(
                    depthimageFramek2.Width, depthimageFramek2.Height, 96, 96, PixelFormats.Bgr24, null, depth32k2, depthimageFramek2.Width * 4);
                    
                    Blob[] MyBlobsk2 = blobcounter(BlobBitmapFeedk2);
                    blobprocessk2(MyBlobsk2, pixelDatak2);

                    slowdown = 0;
                    }

                    else //if (slowdown >10)
                    {
                        slowdown++;
                    }
                }

            
        }

        //Depth camera feed generator END Sensor 2



        //Color camera feed generator start Sensor 2

        void sensor2_ColorFrameReady(object sender, ColorImageFrameReadyEventArgs e)
        {
            using (ColorImageFrame imageFramek2 = e.OpenColorImageFrame())
            {
                // Check if the incoming frame is not null
                if (imageFramek2 == null)
                {
                    return;
                }
                else
                {
                    depth32k2 = new byte[imageFramek2.PixelDataLength * 4];

                    pixelDatak2 = new byte[imageFramek2.PixelDataLength];
                    // Copy the pixel data

                    imageFramek2.CopyPixelDataTo(this.pixelDatak2);
                    // Calculate the stride

                    int stridek2 = imageFramek2.Width * imageFramek2.BytesPerPixel;
                    // assign the bitmap image source into image control

                    colorimageimgk2.Source = BitmapSource.Create(
                    imageFramek2.Width,
                    imageFramek2.Height,
                    96,
                    96,
                    PixelFormats.Bgr32,
                    null,
                    pixelDatak2,
                    stridek2);
                }
            }
        }

        //Color camera feed generator END Sensor 2


        //Depth camera feed generator start Sensor 1
        
        void sensor1_DepthFrameReady(object sender, DepthImageFrameReadyEventArgs e)
        {
            
                using (DepthImageFrame depthimageFrame = e.OpenDepthImageFrame())
                {
                    if (depthimageFrame == null)
                    {
                        return;
                    }
                    if (slowdown == 3)
                     {
                    short[] pixelData = new short[depthimageFrame.PixelDataLength];
                    int stride = depthimageFrame.Width * 2;
                    depthimageFrame.CopyPixelDataTo(pixelData);

                    depth32 = new byte[depthimageFrame.PixelDataLength * 4];
                    this.GetColorPixelDataWithDistance(pixelData);

                    deplthimageimg.Source = BlobBitmapFeed = BitmapSource.Create(
                    depthimageFrame.Width, depthimageFrame.Height, 96, 96, PixelFormats.Bgr24, null, depth32, depthimageFrame.Width * 4);
                    Blob[] MyBlobs = blobcounter(BlobBitmapFeed);
                    blobprocess(MyBlobs, pixelData);
                    slowdown = 0;
                     }
                    else //if (slowdown ==30)
                    {
                        slowdown++;
                    }
                }
                
            

        }




        public double getdistance(short[] depthFrame, int depthIndex) 
        {
            float distance = depthFrame[depthIndex]>> DepthImageFrame.PlayerIndexBitmaskWidth;

            return distance/2000;
        }


        //Generate Markers 2 Start
        public void gereratemarkers2(int x, int y, string id)
        {

            int posx = Convert.ToInt16((x * canvas1.Width) / 640);
            int posy = Convert.ToInt16((y * canvas1.Width) / 480);
            System.Windows.Shapes.Rectangle Rectangle1 = new System.Windows.Shapes.Rectangle();
            Rectangle1.Width = 25;
            Rectangle1.Height = 25;
            Rectangle1.Fill = System.Windows.Media.Brushes.SkyBlue;
            Canvas.SetLeft(Rectangle1, posx - 15);
            Canvas.SetTop(Rectangle1, posy - 15);
            canvas1.Children.Add(Rectangle1);

            //generate textblock start

            TextBlock txt = new TextBlock();
            txt.Text = id;
            txt.FontSize = 15;
            txt.Width = 20;
            txt.Height = 20;
            txt.Foreground = System.Windows.Media.Brushes.Black;
            Canvas.SetLeft(txt, posx - 7);
            Canvas.SetTop(txt, posy - 12);
            canvas2.Children.Add(txt);
            ////generate textblock end


        }

        //Generate Markers 2 End

        //Generate Markers 1 Start
        public void gereratemarkers(int x, int y, string id)
        {

            int posx = Convert.ToInt16((x * canvas1.Width)/640);
            int posy = Convert.ToInt16((y * canvas1.Width) / 480);
            System.Windows.Shapes.Rectangle Rectangle1 = new System.Windows.Shapes.Rectangle();
            Rectangle1.Width = 25;
            Rectangle1.Height = 25;
            Rectangle1.Fill = System.Windows.Media.Brushes.SkyBlue;
            Canvas.SetLeft(Rectangle1, posx - 15);
            Canvas.SetTop(Rectangle1, posy - 15);
            canvas1.Children.Add(Rectangle1);

            //generate textblock start

            TextBlock txt = new TextBlock();
            txt.Text = id;
            txt.FontSize = 15;
            txt.Width = 20;
            txt.Height = 20;
            txt.Foreground = System.Windows.Media.Brushes.Black;
            Canvas.SetLeft(txt, posx-7);
            Canvas.SetTop(txt, posy-12);
            canvas1.Children.Add(txt);
            ////generate textblock end

        
        }

        //Generate Markers 1 End        


        //Depth camera feed generator END Sensor 1
        


        //Blob Counter Start

        public Blob[] blobcounter(BitmapSource bsource)
        {
            Bitmap b = BitmapFromSource(bsource);

            BlobCounter BCounter = new BlobCounter();
         
            ColorFiltering FilterObjects = new ColorFiltering();
        
            BCounter.FilterBlobs = true;
            BCounter.MinWidth =50;
            BCounter.MinHeight =150;

            BCounter.ProcessImage(b);

            
            Blob[] detectedblobs = BCounter.GetObjectsInformation();

            return detectedblobs;
        }

        //Blob Counter End

        //Blob Process Start Kinect 1

        void blobprocess(Blob[] detectedblobs, short[] pixeldata)
        {
            

            currentpos = "";
            prevposition = "";
            prevblobxpos = new int[] { 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 };
            canvas1.Children.Clear();
            if (detectedblobs.Length > 0)
            {

                for (int blobcount = 0; blobcount < detectedblobs.Length; blobcount++)
                {
                    prevblobxpos[blobcount] = currentblobxpos[blobcount]; 
                    currentblobxpos[blobcount] = detectedblobs[blobcount].CenterOfGravity.X;
                    int index = detectedblobs[blobcount].CenterOfGravity.X + detectedblobs[blobcount].CenterOfGravity.Y;
                    goingin(prevblobxpos[blobcount], currentblobxpos[blobcount]);
                    goingout(prevblobxpos[blobcount], currentblobxpos[blobcount]);
                    

                    string distance = string.Format("{0:0.0}" + " m ", getdistance(pixeldata, index));
                    currentpos = currentpos + "ID: " + blobcount.ToString() + " - " + dir + " \n" + "Distance: "+distance+"\n" ;
                    gereratemarkers(detectedblobs[blobcount].CenterOfGravity.X, detectedblobs[blobcount].CenterOfGravity.Y, (detectedblobs[blobcount].ID-1).ToString());
                     
                }

               

               peopleinsidelbl.Content = "IN: " + peopleinside.ToString();
               peopleinlobbylbl.Content = "LOB: " + peopleinlobby.ToString();
               peopleoutsidelbl.Content = "OUT: " + peopleoutside.ToString();
               currentinsidek1 = peopleinside;
               currentoutsidek1 = peopleoutside;
                movementlbl.Content = currentpos;
                createlogfilek1(peopleinside,peopleoutside);


               ////logfile

               //if ((currentinsidek1 != previnsidek1)||(currentoutsidek1!=prevoutsidek1))
               //{
               //    StreamWriter log;
               //    if (!File.Exists("kinect1.txt"))
               //    {
               //        log = new StreamWriter("kinect1.txt");
               //    }
               //    else
               //    {
               //        log = File.AppendText("kinect1.txt");
               //    }

               //    // Write to the file:
               //    log.WriteLine("At Time" + DateTime.Now);
               //    log.WriteLine(peopleinsidelbl.Content);
               //    log.WriteLine(peopleoutsidelbl.Content);
               //    //.WriteLine(lbldepthk1.Content);
               //    log.WriteLine();

               //    // Close the stream:
               //    log.Close();

               //    previnsidek1 = currentinsidek1;
               //    prevoutsidek1 = currentoutsidek1;
               //}

            }

            else //if (detectedblobs.Length > 0)
            { 
            

            
            }


        }


        private void createlogfilek1(int peopleinside, int peopleoutside)
        {
            //logfile

            if ((currentinsidek1 != previnsidek1) || (currentoutsidek1 != prevoutsidek1))
            {
                StreamWriter log;
                if (!File.Exists("kinect1.txt"))
                {
                    log = new StreamWriter("kinect1.txt");
                }
                else
                {
                    log = File.AppendText("kinect1.txt");
                }

                // Write to the file
                log.Write(DateTime.Now);
                log.Write(" "+peopleinsidelbl.Content);
                log.Write(" " + peopleoutsidelbl.Content);
                //.WriteLine(lbldepthk1.Content);
                log.WriteLine();

                // Close the stream:
                log.Close();

                previnsidek1 = currentinsidek1;
                prevoutsidek1 = currentoutsidek1;
            }
           // throw new NotImplementedException();
        }

        //Blob Process End Kinect 1

        //Blob Process Start Kinect 2

        void blobprocessk2(Blob[] detectedblobsk2, short[] pixeldatak2)
        {

            currentposk2 = "";
            prevpositionk2 = "";
            prevblobxposk2 = new int[] { 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 };

            if (detectedblobsk2.Length > 0)
            {

                for (int blobcountk2 = 0; blobcountk2 < detectedblobsk2.Length; blobcountk2++)
                {
                    prevblobxposk2[blobcountk2] = currentblobxposk2[blobcountk2];
                    currentblobxposk2[blobcountk2] = detectedblobsk2[blobcountk2].CenterOfGravity.X;
                    int indexk2 = detectedblobsk2[blobcountk2].CenterOfGravity.X + detectedblobsk2[blobcountk2].CenterOfGravity.Y;
                  
                    goingink2(prevblobxposk2[blobcountk2], currentblobxposk2[blobcountk2]);
                    goingoutk2(prevblobxposk2[blobcountk2], currentblobxposk2[blobcountk2]);
                    string distancek2 = string.Format("{0:0.0}" + " m ", getdistance(pixeldatak2, indexk2));

                    currentposk2 = currentposk2 + "ID: " + blobcountk2.ToString() + " - " + dirk2 + " \n" + "Distance: " + distancek2 + "\n";
                    gereratemarkers2(detectedblobsk2[blobcountk2].CenterOfGravity.X, detectedblobsk2[blobcountk2].CenterOfGravity.Y, (detectedblobsk2[blobcountk2].ID - 1).ToString());
                
                }



                peopleinsidelblk2.Content = "IN: " + peopleinsidek2.ToString();
                peopleinlobbylblk2.Content = "LOB: " + peopleinlobbyk2.ToString();
                peopleoutsidelblk2.Content = "OUT: " + peopleoutsidek2.ToString();
                currentinsidek2 = peopleinsidek2;
                currentoutsidek2 = peopleoutsidek2;
                movementlblk2.Content = currentposk2;
                createlogfilek2(peopleinsidek2, peopleoutsidek2);
               
            }

            else //if (detectedblobs.Length > 0)
            {



            }


        }

        private void createlogfilek2(int peopleinsidek2, int peopleoutsidek2)
        {
            //logfile

            if ((currentinsidek2 != previnsidek2) || (currentoutsidek2 != prevoutsidek2))
            {
                StreamWriter log;
                if (!File.Exists("kinect2.txt"))
                {
                    log = new StreamWriter("kinect2.txt");
                }
                else
                {
                    log = File.AppendText("kinect2.txt");
                }

                // Write to the file:
                log.Write(DateTime.Now);
                log.Write(" "+peopleinsidelblk2.Content);
                log.Write(" "+peopleoutsidelblk2.Content);
                //.WriteLine(lbldepthk1.Content);
                log.WriteLine();

                // Close the stream:
                log.Close();
                previnsidek2 = currentinsidek2;
                prevoutsidek2 = currentoutsidek2;
            } 
          //  throw new NotImplementedException();
        }

        //Blob Process End Kinect 2




        //color camera feed generator start sensor 1

        void sensor1_ColorFrameReady(object sender, ColorImageFrameReadyEventArgs e)
        {

            using (ColorImageFrame imageFrame = e.OpenColorImageFrame())
            {
                // Check if the incoming frame is not null
                if (imageFrame == null)
                {
                    return;
                }
                else
                {
                    depth32 = new byte[imageFrame.PixelDataLength * 4];

                    pixelData = new byte[imageFrame.PixelDataLength];
                    // Copy the pixel data

                    imageFrame.CopyPixelDataTo(this.pixelData);
                    // Calculate the stride
                    
                    int stride = imageFrame.Width * imageFrame.BytesPerPixel;
                    // assign the bitmap image source into image control
                    
                    colorimageimg.Source = BitmapSource.Create(
                    imageFrame.Width,
                    imageFrame.Height,
                    96,
                    96,
                    PixelFormats.Bgr32,
                    null,
                    pixelData,
                    stride);
                }

            }

            //color camera feed generator end sensor 1
      

          }


        //change depth stream to blobs on picture start Kinect 1
        private void GetColorPixelDataWithDistance(short[] depthFrame)
        {
            for (int depthIndex = 0, colorIndex = 0; depthIndex < depthFrame.Length && colorIndex < this.depth32.Length; depthIndex++, colorIndex += 4)
            {
                // Calculate the depth distance
                int distance = depthFrame[depthIndex] >> DepthImageFrame.PlayerIndexBitmaskWidth;
                // Colorize pixels for a range of distance
                if (distance <= 600)
                {
                    depth32[colorIndex + 2] = 0;
                    depth32[colorIndex + 1] = 0;
                    depth32[colorIndex + 0] = 0;

                }
                else if (distance > 601 && distance <= 1800)
                {

                    depth32[colorIndex + 2] = 255; // red
                    depth32[colorIndex + 1] = 255;  // green
                    depth32[colorIndex + 0] = 255; // blue

                }
                else if (distance > 1801)
                {
                    depth32[colorIndex + 2] = 0;
                    depth32[colorIndex + 1] = 0;
                    depth32[colorIndex + 0] = 0;
                }
            }
        }
        //change depth stream to blobs on picture end kinect 1

        //change depth stream to blobs on picture start kinect 2
        private void GetColorPixelDataWithDistancek2(short[] depthFramek2)
        {
            for (int depthIndexk2 = 0, colorIndexk2 = 0; depthIndexk2 < depthFramek2.Length && colorIndexk2 < this.depth32k2.Length; depthIndexk2++, colorIndexk2 += 4)
            {
                // Calculate the depth distance
                int distancek2 = depthFramek2[depthIndexk2] >> DepthImageFrame.PlayerIndexBitmaskWidth;
                // Colorize pixels for a range of distance
                if (distancek2 <= 900)
                {
                    depth32k2[colorIndexk2 + 2] = 0;
                    depth32k2[colorIndexk2 + 1] = 0;
                    depth32k2[colorIndexk2 + 0] = 0;

                }
                else if (distancek2 > 901 && distancek2 <= 2500)
                {

                    depth32k2[colorIndexk2 + 2] = 255; // red
                    depth32k2[colorIndexk2 + 1] = 255;  // green
                    depth32k2[colorIndexk2 + 0] = 255; // blue

                }
                else if (distancek2 > 2501)
                {
                    depth32k2[colorIndexk2 + 2] = 0;
                    depth32k2[colorIndexk2 + 1] = 0;
                    depth32k2[colorIndexk2 + 0] = 0;
                }
            }
        }
        //change depth stream to blobs on picture end kinect 2


        //Bitmap Source to Bitmap Convertor Start
        public System.Drawing.Bitmap BitmapFromSource(BitmapSource bitmapsource)
        {
            System.Drawing.Bitmap bitmap;
            using (MemoryStream outStream = new MemoryStream())
            {
                BitmapEncoder enc = new BmpBitmapEncoder();
                enc.Frames.Add(BitmapFrame.Create(bitmapsource));
                enc.Save(outStream);
                bitmap = new System.Drawing.Bitmap(outStream);
            }
            return bitmap;
        }

        //Bitmap Source to Bitmap Convertor End



        //Going IN Calc Start Kinect 1

        public void goingin(int prev, int current)
        {


            if (current - prev > 0)
            {
                dir = "Going In";

                if (current > 320 && (prev < 321 && prev > 160))
                {
                    peopleinside++;

                }
                //lobby to in counter start
                
            }
        }

        //Going IN Calc End Kinect 1


        //Going OUT Calc Start kinect1

        public void goingout(int prev, int current)
        {

            if (current - prev < 0)
            {
                dir = "Going OUT";


                if (current < 321 && (prev < 500 && prev > 320))
                {
                    peopleoutside++;

                }    
            
            }
        }

        //Going Out Calc End kinect 1





        //Going IN Calc Start Kinect 2

        public void goingink2(int prevk2, int currentk2)
        {

            if (currentk2 - prevk2 > 0)
            {
                dir = "Going In";

                if (currentk2 > 320 && (prevk2 < 321 && prevk2 > 0))
                {
                    peopleinsidek2++;

                }
                //lobby to in counter start

            }


        }

        //Going IN Calc End Kinect 2


        //Going OUT Calc Start kinect2

        public void goingoutk2(int prevk2, int currentk2)
        {


            if (currentk2 - prevk2 < 0)
            {
                dir = "Going OUT";


                if (currentk2 < 321 && (prevk2 < 640 && prevk2 > 320))
                {
                    peopleoutsidek2++;

                }    
            }

        }

        //Going Out Calc End kinect 2

        }
    }
