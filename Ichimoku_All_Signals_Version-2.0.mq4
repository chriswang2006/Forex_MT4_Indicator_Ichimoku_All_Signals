//+------------------------------------------------------------------+
//|                                   Ichimoku_All_Signals_V-2.0.mq4 |
//|                                                   Copyright 2017 |
//|                                email:Chris.Wang.2006@hotmail.com |
//|                                                wx: chriswang3744 |
//+------------------------------------------------------------------+

//+------------------------------------------------------------------+
//|Feature Description:                                              |
//| * |
//| * |
//+------------------------------------------------------------------+

#property copyright   "Copyright 2017"
#property link        "Chris.Wang.2006@hotmail.com"
#property description "Ichimoku_Signal_V2"

//--- indicator settings
#property indicator_chart_window
#property indicator_buffers 22
#property indicator_color1  Red
#property indicator_color2  DodgerBlue
#property indicator_color3  Red
#property indicator_color4  DodgerBlue
#property indicator_color5  Red
#property indicator_color6  DodgerBlue
#property indicator_color7  Red
#property indicator_color8  DodgerBlue
#property indicator_color9  Red
#property indicator_color10  DodgerBlue
#property indicator_color11  Red
#property indicator_color12  DodgerBlue
#property indicator_color13  Red
#property indicator_color14  DodgerBlue
#property indicator_color15  Red
#property indicator_color16  DodgerBlue
#property indicator_color17  Red
#property indicator_color18  DodgerBlue
#property indicator_color19  Red
#property indicator_color20  DodgerBlue
#property indicator_color21  Red
#property indicator_color22  DodgerBlue

#property indicator_style1  STYLE_SOLID
#property indicator_style2  STYLE_SOLID
#property indicator_style3  STYLE_SOLID
#property indicator_style4  STYLE_SOLID
#property indicator_style5  STYLE_SOLID
#property indicator_style6  STYLE_SOLID
#property indicator_style5  STYLE_SOLID
#property indicator_style6  STYLE_SOLID
#property indicator_style7  STYLE_SOLID
#property indicator_style8  STYLE_SOLID
#property indicator_style9  STYLE_SOLID
#property indicator_style10  STYLE_SOLID
#property indicator_style11  STYLE_SOLID
#property indicator_style12  STYLE_SOLID
#property indicator_style13  STYLE_SOLID
#property indicator_style14  STYLE_SOLID
#property indicator_style15  STYLE_SOLID
#property indicator_style16  STYLE_SOLID
#property indicator_style15  STYLE_SOLID
#property indicator_style16  STYLE_SOLID
#property indicator_style17  STYLE_SOLID
#property indicator_style18  STYLE_SOLID
#property indicator_style19  STYLE_SOLID
#property indicator_style20  STYLE_SOLID
#property indicator_style21  STYLE_SOLID
#property indicator_style22  STYLE_SOLID

//--- input parameter

//--- buffers Chikou Span
double CPUPBuffer[];    // Chikou Span, Price Buy
double CPDNBuffer[];    // Chikou Span, Price Sell

double CTUPBuffer[];    // Chikou Span, Tenkan Sen Buy
double CTDNBuffer[];    // Chikou Span, Tenkan Sen Sell

double CKUPBuffer[];    // Chikou Span, Kijun Sen Buy
double CKDNBuffer[];    // Chikou Span, Kijun Sen Sell

double CCUPBuffer[];    // Chikou Span, Cloud Buy
double CCDNBuffer[];    // Chikou Span, Cloud Sell

//--- buffers Price
double PTUPBuffer[];    // Price,Tenkan Sen Buy
double PTDNBuffer[];    // Price,Tenkan Sen Sell

double PKUPBuffer[];    // Price,Kijun Sen Buy
double PKDNBuffer[];    // Price,Kijun Sen Sell

double PCUPBuffer[];    // Price,Cloud Buy
double PCDNBuffer[];    // Price,Cloud Sell

//--- buffers Tenkan Sen

double TKUPBuffer[];    //Tenkan,Kijun Buy
double TKDNBuffer[];    //Tenkan,Kijun Sell

double TCUPBuffer[];    //Tenkan,Cloud Buy
double TCDNBuffer[];    //Tenkan,Cloud Sell

//--- buffers Kijun Sen

double KCUPBuffer[];      //Kijun,Cloud Buy
double KCDNBuffer[];      //Kijun,Cloud Sell

//--- buffers Senkou Span A
double SSABUPBuffer[];    // Senkou Span A,B Buy
double SSABDNBuffer[];    // Senkou Span A,B Sell


//--- buffers Confirmation

double CPCBuffer[];      // Price/Kumo Confirmation: UP=1,MD=0,DN=-1,
double PKCBuffer[];      // Price/Kumo Confirmation: UP=1,MD=0,DN=-1,



extern int Signal_Filter_Level=3;  // Weak=1,Neutral=2,Srong=3

extern int Tenkan=9;   // Tenkan-sen
extern int Kijun=26;   // Kijun-sen
extern int Senkou=52;  // Senkou Span 




extern bool  ShowChikouSpanPriceCross_0         = true;
extern bool  ShowChikouSpanTenkanSenCross_1     = true;
extern bool  ShowChikouSpanKijunSenCross_2      = true;
extern bool  ShowChikouSpanCloudCross_3         = true;

extern bool  ShowPriceTenkanSenCross_4          = true;
extern bool  ShowPriceKijunSenCross_5           = true;
extern bool  ShowPriceCloudCross_6              = true;

extern bool  ShowTenkanSenKijunSenCross_7       = true;
extern bool  ShowTenkanSenCloudCross_8          = true;

extern bool  ShowKijunSenCloudCross_9           = true;

extern bool  ShowSenkouSpanABCross_10           = true;

extern bool  EnableChikouSpanPriceConfirmation  = true;
extern bool  EnablePriceKumoConfirmation        = true;

extern bool  EnableAlert                        = true;

int Signal_Default_Level                        = 1;

datetime pTime;
string short_name;
//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int OnInit(void)
  {

//--- name for DataWindow and indicator subwindow label
   short_name="Price_Action_Ichimoku_Signal_V2 ("+string(Tenkan)+" "+string(Kijun)+" "+string(Senkou)+")";
   IndicatorShortName(short_name);

//--- 1 additional buffer used for counting.
   IndicatorBuffers(24);
   IndicatorDigits(Digits);

//--- indicator line

//--- Signal 0:
   SetIndexStyle(0,DRAW_ARROW,STYLE_SOLID,2);
   SetIndexArrow(0,128);
   SetIndexBuffer(0,CPUPBuffer);
   SetIndexLabel(0,"Chikou Span/Price Buy");
   SetIndexDrawBegin(0,2);
   SetIndexEmptyValue(0,0);

   SetIndexStyle(1,DRAW_ARROW,STYLE_SOLID,2);
   SetIndexArrow(1,128);
   SetIndexBuffer(1,CPDNBuffer);
   SetIndexLabel(1,"Chikou Span/Price Sell");
   SetIndexDrawBegin(1,2);
   SetIndexEmptyValue(1,0);

   if(!ShowChikouSpanPriceCross_0)
     {
      SetIndexStyle(0,DRAW_NONE);
      SetIndexStyle(1,DRAW_NONE);

     }

//--- Signal 1:

   SetIndexStyle(2,DRAW_ARROW,STYLE_SOLID,2);
   SetIndexArrow(2,129);
   SetIndexBuffer(2,CTUPBuffer);
   SetIndexLabel(2,"Chikou Span/Tenkan Sen Buy");
   SetIndexDrawBegin(2,2);
   SetIndexEmptyValue(2,0);

   SetIndexStyle(3,DRAW_ARROW,STYLE_SOLID,2);
   SetIndexArrow(3,129);
   SetIndexBuffer(3,CTDNBuffer);
   SetIndexLabel(3,"Chikou Span/Tenkan Sen Sell");
   SetIndexDrawBegin(3,2);
   SetIndexEmptyValue(3,0);

   if(!ShowChikouSpanTenkanSenCross_1)
     {
      SetIndexStyle(2,DRAW_NONE);
      SetIndexStyle(3,DRAW_NONE);

     }

//--- Signal 2:

   SetIndexStyle(4,DRAW_ARROW,STYLE_SOLID,2);
   SetIndexArrow(4,130);
   SetIndexBuffer(4,CKUPBuffer);
   SetIndexLabel(4,"Chikou Span/Kijun Sen Buy");
   SetIndexDrawBegin(4,2);
   SetIndexEmptyValue(4,0);

   SetIndexStyle(5,DRAW_ARROW,STYLE_SOLID,2);
   SetIndexArrow(5,130);
   SetIndexBuffer(5,CKDNBuffer);
   SetIndexLabel(5,"Chikou Span/Kijun Sen Sell");
   SetIndexDrawBegin(5,2);
   SetIndexEmptyValue(5,0);

   if(!ShowChikouSpanKijunSenCross_2)
     {
      SetIndexStyle(4,DRAW_NONE);
      SetIndexStyle(5,DRAW_NONE);

     }

//--- Signal 3:

   SetIndexStyle(6,DRAW_ARROW,STYLE_SOLID,2);
   SetIndexArrow(6,131);
   SetIndexBuffer(6,CCUPBuffer);
   SetIndexLabel(6,"Chikou Span/Cloud Buy");
   SetIndexDrawBegin(6,2);
   SetIndexEmptyValue(6,0);

   SetIndexStyle(7,DRAW_ARROW,STYLE_SOLID,2);
   SetIndexArrow(7,131);
   SetIndexBuffer(7,CCDNBuffer);
   SetIndexLabel(7,"Chikou Span/Cloud Sell");
   SetIndexDrawBegin(7,2);
   SetIndexEmptyValue(7,0);

   if(!ShowChikouSpanCloudCross_3)
     {
      SetIndexStyle(6,DRAW_NONE);
      SetIndexStyle(7,DRAW_NONE);

     }

//--- Signal 4:

   SetIndexStyle(8,DRAW_ARROW,STYLE_SOLID,2);
   SetIndexArrow(8,132);
   SetIndexBuffer(8,PTUPBuffer);
   SetIndexLabel(8,"Price/Tenkan Sen Buy");
   SetIndexDrawBegin(8,2);
   SetIndexEmptyValue(8,0);

   SetIndexStyle(9,DRAW_ARROW,STYLE_SOLID,2);
   SetIndexArrow(9,132);
   SetIndexBuffer(9,PTDNBuffer);
   SetIndexLabel(9,"Price/Tenkan Sen Sell");
   SetIndexDrawBegin(9,2);
   SetIndexEmptyValue(9,0);

   if(!ShowPriceTenkanSenCross_4)
     {
      SetIndexStyle(8,DRAW_NONE);
      SetIndexStyle(9,DRAW_NONE);

     }

//--- Signal 5:

   SetIndexStyle(10,DRAW_ARROW,STYLE_SOLID,2);
   SetIndexArrow(10,133);
   SetIndexBuffer(10,PKUPBuffer);
   SetIndexLabel(10,"Price/Kijun Sen Buy");
   SetIndexDrawBegin(10,2);
   SetIndexEmptyValue(10,0);

   SetIndexStyle(11,DRAW_ARROW,STYLE_SOLID,2);
   SetIndexArrow(11,133);
   SetIndexBuffer(11,PKDNBuffer);
   SetIndexLabel(11,"Price/Kijun Sen Sell");
   SetIndexDrawBegin(11,2);
   SetIndexEmptyValue(11,0);

   if(!ShowPriceKijunSenCross_5)
     {
      SetIndexStyle(10,DRAW_NONE);
      SetIndexStyle(11,DRAW_NONE);

     }

//--- Signal 6:

   SetIndexStyle(12,DRAW_ARROW,STYLE_SOLID,2);
   SetIndexArrow(12,134);
   SetIndexBuffer(12,PCUPBuffer);
   SetIndexLabel(12,"Price/Cloud Buy");
   SetIndexDrawBegin(12,2);
   SetIndexEmptyValue(12,0);

   SetIndexStyle(13,DRAW_ARROW,STYLE_SOLID,2);
   SetIndexArrow(13,134);
   SetIndexBuffer(13,PCDNBuffer);
   SetIndexLabel(13,"Price/Cloud Sell");
   SetIndexDrawBegin(13,2);
   SetIndexEmptyValue(13,0);

   if(!ShowPriceCloudCross_6)
     {
      SetIndexStyle(12,DRAW_NONE);
      SetIndexStyle(13,DRAW_NONE);

     }

//--- Signal 7:

   SetIndexStyle(14,DRAW_ARROW,STYLE_SOLID,2);
   SetIndexArrow(14,135);
   SetIndexBuffer(14,TKUPBuffer);
   SetIndexLabel(14,"Tenkan Sen/Kijun Sen Buy");
   SetIndexDrawBegin(14,2);
   SetIndexEmptyValue(14,0);

   SetIndexStyle(15,DRAW_ARROW,STYLE_SOLID,2);
   SetIndexArrow(15,135);
   SetIndexBuffer(15,TKDNBuffer);
   SetIndexLabel(15,"Tenkan Sen/Kijun Sen Sell");
   SetIndexDrawBegin(15,2);
   SetIndexEmptyValue(15,0);

   if(!ShowTenkanSenKijunSenCross_7)
     {
      SetIndexStyle(14,DRAW_NONE);
      SetIndexStyle(15,DRAW_NONE);

     }

//--- Signal 8:

   SetIndexStyle(16,DRAW_ARROW,STYLE_SOLID,2);
   SetIndexArrow(16,136);
   SetIndexBuffer(16,TCUPBuffer);
   SetIndexLabel(16,"Tenkan Sen/Cloud Buy");
   SetIndexDrawBegin(16,2);
   SetIndexEmptyValue(16,0);

   SetIndexStyle(17,DRAW_ARROW,STYLE_SOLID,2);
   SetIndexArrow(17,136);
   SetIndexBuffer(17,TCDNBuffer);
   SetIndexLabel(17,"Tenkan Sen/Cloud Sell");
   SetIndexDrawBegin(17,2);
   SetIndexEmptyValue(17,0);

   if(!ShowTenkanSenCloudCross_8)
     {
      SetIndexStyle(16,DRAW_NONE);
      SetIndexStyle(17,DRAW_NONE);

     }

//--- Signal 9:

   SetIndexStyle(18,DRAW_ARROW,STYLE_SOLID,2);
   SetIndexArrow(18,137);
   SetIndexBuffer(18,KCUPBuffer);
   SetIndexLabel(18,"Kijun Sen/Cloud Buy");
   SetIndexDrawBegin(18,2);
   SetIndexEmptyValue(18,0);

   SetIndexStyle(19,DRAW_ARROW,STYLE_SOLID,2);
   SetIndexArrow(19,137);
   SetIndexBuffer(19,KCDNBuffer);
   SetIndexLabel(19,"Kijun Sen/Cloud Sell");
   SetIndexDrawBegin(19,2);
   SetIndexEmptyValue(19,0);

   if(!ShowKijunSenCloudCross_9)
     {
      SetIndexStyle(18,DRAW_NONE);
      SetIndexStyle(19,DRAW_NONE);

     }

//--- Signal 10:

   SetIndexStyle(20,DRAW_ARROW,STYLE_SOLID,2);
   SetIndexArrow(20,138);
   SetIndexBuffer(20,SSABUPBuffer);
   SetIndexLabel(20,"Senkou Span A/B Buy");
   SetIndexDrawBegin(20,2);
   SetIndexEmptyValue(20,0);

   SetIndexStyle(21,DRAW_ARROW,STYLE_SOLID,2);
   SetIndexArrow(21,138);
   SetIndexBuffer(21,SSABDNBuffer);
   SetIndexLabel(21,"Senkou Span A/B Sell");
   SetIndexDrawBegin(21,2);
   SetIndexEmptyValue(21,0);

   if(!ShowSenkouSpanABCross_10)
     {
      SetIndexStyle(20,DRAW_NONE);
      SetIndexStyle(21,DRAW_NONE);

     }

   SetIndexBuffer(22,CPCBuffer);
   SetIndexDrawBegin(22,2);
   SetIndexEmptyValue(22,EMPTY_VALUE);

   SetIndexBuffer(23,PKCBuffer);
   SetIndexDrawBegin(23,2);
   SetIndexEmptyValue(23,EMPTY_VALUE);

//--- check for input parameter

   pTime=iTime(NULL,0,0);

//---
   return(INIT_SUCCEEDED);
  }


//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int OnCalculate(const int rates_total,
                const int prev_calculated,
                const datetime &time[],
                const double &open[],
                const double &high[],
                const double &low[],
                const double &close[],
                const long &tick_volume[],
                const long &volume[],
                const int &spread[])
  {

//--- return value of prev_calculated for next call   

   int i,limit;
   double coef=0.8;

//--- check for bars count and input parameter
   if(rates_total<=Senkou)
      return(0);
//--- counting from 0 to rates_total

//--- preliminary calculations
   if(prev_calculated==0)
      limit=rates_total-Senkou-1;
   else
      limit=rates_total-prev_calculated+1;

   for(i=limit; i>0; i--)
     {

      // confiremation
      double price_high =high[i]+iATR(NULL,0,10,i)*coef;
      double price_low  =low[i] -iATR(NULL,0,10,i)*coef;

      double x1,x0,y1,y0;
      double t1,t0;

      t1 = getTenkanSen(i+1);
      t0 = getTenkanSen(i);

      //
      // arrow 0
      //
      if(ShowChikouSpanPriceCross_0)
        {
         x1 = getChikouSpan(i+Kijun+1);
         x0 = getChikouSpan(i+Kijun);
         y1 = close[i+Kijun+1];
         y0 = close[i+Kijun];

         if(checkCrossUP(x1,x0,y1,y0))
           {
            CPUPBuffer[i]=price_low;
           }
         if(checkCrossDN(x1,x0,y1,y0))
           {
            CPDNBuffer[i]=price_high;
           }
        }

      //
      // arrow 1 
      // 
      if(ShowChikouSpanTenkanSenCross_1)
        {
         x1 = getChikouSpan(i+Kijun+1);
         x0 = getChikouSpan(i+Kijun);
         y1 = getTenkanSen(i+Kijun+1);
         y0 = getTenkanSen(i+Kijun);

         if(checkCrossUP(x1,x0,y1,y0))
           {
            CTUPBuffer[i]=price_low;

           }
         if(checkCrossDN(x1,x0,y1,y0))
           {
            CTDNBuffer[i]=price_high;

           }
        }

      //
      // arrow 2
      //
      if(ShowChikouSpanKijunSenCross_2)
        {
         x1 = getChikouSpan(i+Kijun+1);
         x0 = getChikouSpan(i+Kijun);

         y1 = getKijunSen(i+Kijun+1);
         y0 = getKijunSen(i+Kijun);

         if(checkCrossUP(x1,x0,y1,y0))

           {
            CKUPBuffer[i]=price_low;

           }
         if(checkCrossDN(x1,x0,y1,y0))

           {
            CKDNBuffer[i]=price_high;

           }
        }

      //
      // arrow 3
      //
      if(ShowChikouSpanCloudCross_3)
        {
         x1=getChikouSpan(i+Kijun+1);
         x0=getChikouSpan(i+Kijun);

         y1 = MathMax(getSenkouSpanA(i+Kijun+1),getSenkouSpanB(i+Kijun+1));
         y0 = MathMax(getSenkouSpanA(i+Kijun),  getSenkouSpanB(i+Kijun));
         if(checkCrossUP(x1,x0,y1,y0))

           {
            CCUPBuffer[i]=price_low;

           }

         y1 = MathMin(getSenkouSpanA(i+Kijun+1),getSenkouSpanB(i+Kijun+1));
         y0 = MathMin(getSenkouSpanA(i+Kijun),  getSenkouSpanB(i+Kijun));
         if(checkCrossDN(x1,x0,y1,y0))

           {
            CCDNBuffer[i]=price_high;

           }
        }

      //
      // arrow 4
      //
      if(ShowPriceTenkanSenCross_4)
        {

         x1 = close[i+1];
         x0 = close[i];
         y1 = getTenkanSen(i+1);
         y0 = getTenkanSen(i);


         if(checkCrossUP(x1,x0,y1,y0))

           {
            PTUPBuffer[i]=price_low;

           }
         if(checkCrossDN(x1,x0,y1,y0))

           {
            PTDNBuffer[i]=price_high;

           }
        }

      //
      // arrow 5
      //
      if(ShowPriceKijunSenCross_5)
        {
         x1=close[i+1];
         x0 = close[i];
         y1 = getKijunSen(i+1);
         y0 = getKijunSen(i);

         if(checkCrossUP(x1,x0,y1,y0))

           {
            PKUPBuffer[i]=price_low;

           }
         if(checkCrossDN(x1,x0,y1,y0))

           {
            PKDNBuffer[i]=price_high;

           }
        }

      //
      // arrow 6
      //
      if(ShowPriceCloudCross_6)
        {
         x1=close[i+1];
         x0= close[i];

         y1 = MathMax(getSenkouSpanA(i+1),getSenkouSpanB(i+1));
         y0 = MathMax(getSenkouSpanA(i),  getSenkouSpanB(i));

         if(checkCrossUP(x1,x0,y1,y0)
            //&& t1<t0
            )

           {
            PCUPBuffer[i]=price_low;

           }

         y1 = MathMin(getSenkouSpanA(i+1),getSenkouSpanB(i+1));
         y0 = MathMin(getSenkouSpanA(i),  getSenkouSpanB(i));

         if(checkCrossDN(x1,x0,y1,y0)
            //&& t1>t0

            )

           {
            PCDNBuffer[i]=price_high;

           }
        }

      //
      // arrow 7
      //
      if(ShowTenkanSenKijunSenCross_7)
        {

         x1 = getTenkanSen(i+1);
         x0 = getTenkanSen(i);
         y1 = getKijunSen(i+1);
         y0 = getKijunSen(i);

         if(checkCrossUP(x1,x0,y1,y0))

           {
            TKUPBuffer[i]=price_low;

           }
         if(checkCrossDN(x1,x0,y1,y0))

           {
            TKDNBuffer[i]=price_high;

           }
        }

      //
      // arrow 8
      //
      if(ShowTenkanSenCloudCross_8)
        {
         x1=getTenkanSen(i+1);
         x0=getTenkanSen(i);

         y1 = MathMax(getSenkouSpanA(i+1),getSenkouSpanB(i+1));
         y0 = MathMax(getSenkouSpanA(i),  getSenkouSpanB(i));

         if(checkCrossUP(x1,x0,y1,y0))

           {
            TCUPBuffer[i]=price_low;

           }

         y1 = MathMin(getSenkouSpanA(i+1),getSenkouSpanB(i+1));
         y0 = MathMin(getSenkouSpanA(i),  getSenkouSpanB(i));

         if(checkCrossDN(x1,x0,y1,y0))

           {
            TCDNBuffer[i]=price_high;

           }
        }

      //
      // arrow 9
      //
      if(ShowKijunSenCloudCross_9)
        {
         x1 = getKijunSen(i+1);
         x0 = getKijunSen(i);

         y1 = MathMax(getSenkouSpanA(i+1),getSenkouSpanB(i+1));
         y0 = MathMax(getSenkouSpanA(i),  getSenkouSpanB(i));

         if(checkCrossUP(x1,x0,y1,y0))

           {
            KCUPBuffer[i]=price_low;

           }

         y1 = MathMin(getSenkouSpanA(i+1),getSenkouSpanB(i+1));
         y0 = MathMin(getSenkouSpanA(i),  getSenkouSpanB(i));

         if(checkCrossDN(x1,x0,y1,y0))

           {
            KCDNBuffer[i]=price_high;

           }
        }
      //
      // arrow 10
      //

      if(ShowSenkouSpanABCross_10)
        {
         x1 = getSenkouSpanA(i-Kijun+1);
         x0 = getSenkouSpanA(i-Kijun);
         y1 = getSenkouSpanB(i-Kijun+1);
         y0 = getSenkouSpanB(i-Kijun);

         if(checkCrossUP(x1,x0,y1,y0))

           {
            SSABUPBuffer[i]=price_low;

           }

         if(checkCrossDN(x1,x0,y1,y0))

           {
            SSABDNBuffer[i]=price_high;

           }
        }

      //
      // confirmation CPC
      //
      if(close[i+Kijun]<getChikouSpan(i))
         CPCBuffer[i]=1;
      else if(close[i+Kijun]>getChikouSpan(i))
         CPCBuffer[i]=-1;
      else
         CPCBuffer[i]=0;

      //
      // confirmation PKC
      //
      if(close[i]>MathMax(getSenkouSpanA(i),getSenkouSpanB(i)))
         PKCBuffer[i]=1;
      else if(close[i]<MathMin(getSenkouSpanA(i),getSenkouSpanB(i)))
         PKCBuffer[i]=-1;
      else
         PKCBuffer[i]=0;

      //----------------------------------------------------
      // Process filter
      //----------------------------------------------------

      // filter 0
      SignalFilterUP(CPUPBuffer,i);
      SignalFilterDN(CPDNBuffer,i);

      // filter 1
      SignalFilterUP(CTUPBuffer,i);
      SignalFilterDN(CTDNBuffer,i);

      // filter 2
      SignalFilterUP(CKUPBuffer,i);
      SignalFilterDN(CKDNBuffer,i);

      // filter 3
      SignalFilterUP(CCUPBuffer,i);
      SignalFilterDN(CCDNBuffer,i);

      // filter 4
      SignalFilterUP(PTUPBuffer,i);
      SignalFilterDN(PTDNBuffer,i);

      // filter 5
      SignalFilterUP(PKUPBuffer,i);
      SignalFilterDN(PKDNBuffer,i);

      // filter 6
      SignalFilterUP(PCUPBuffer,i);
      SignalFilterDN(PCDNBuffer,i);

      // filter 7
      SignalFilterUP(TKUPBuffer,i);
      SignalFilterDN(TKDNBuffer,i);

      // filter 8
      SignalFilterUP(TCUPBuffer,i);
      SignalFilterDN(TCDNBuffer,i);

      // filter 9
      SignalFilterUP(KCUPBuffer,i);
      SignalFilterDN(KCDNBuffer,i);

      // filter 10
      SignalFilterUP(SSABUPBuffer,i);
      SignalFilterDN(SSABDNBuffer,i);

      //-----
     }

//
// process alert
//       
   i=1;

   if(EnableAlert && isNewBar())
     {

      // signal 0
      if(ShowChikouSpanPriceCross_0)
        {
         if(CPUPBuffer[i]>0)
            Alert(Symbol()+" "+timeframeToString(Period())+" "+short_name+" Signal: Chikou Span/Price Buy");
         if(CPDNBuffer[i]>0)
            Alert(Symbol()+" "+timeframeToString(Period())+" "+short_name+" Signal: Chikou Span/Price Sell");
        }
      
      // signal 1
      if(ShowChikouSpanTenkanSenCross_1)
        {
         if(CTUPBuffer[i]>0)
            Alert(Symbol()+" "+timeframeToString(Period())+" "+short_name+" Signal: Chikou Span/Tenkan Sen Buy");
         if(CTDNBuffer[i]>0)
            Alert(Symbol()+" "+timeframeToString(Period())+" "+short_name+" Signal: Chikou Span/Tenkan Sen Sell");
        }
      
      // signal 2
      if(ShowChikouSpanKijunSenCross_2)
        {
         if(CKUPBuffer[i]>0)
            Alert(Symbol()+" "+timeframeToString(Period())+" "+short_name+" Signal: Chikou Span/Kijun Sen Buy");
         if(CKDNBuffer[i]>0)
            Alert(Symbol()+" "+timeframeToString(Period())+" "+short_name+" Signal: Chikou Span/Kijun Sen Sell");
        }
      
      // signal 3
      if(ShowChikouSpanCloudCross_3)
        {
         if(CCUPBuffer[i]>0)
            Alert(Symbol()+" "+timeframeToString(Period())+" "+short_name+" Signal: Chikou Span/Cloud Buy");
         if(CCDNBuffer[i]>0)
            Alert(Symbol()+" "+timeframeToString(Period())+" "+short_name+" Signal: Chikou Span/Cloud Sell");
        }
      
      // signal 4
      if(ShowPriceTenkanSenCross_4)
        {
         if(PTUPBuffer[i]>0)
            Alert(Symbol()+" "+timeframeToString(Period())+" "+short_name+" Signal: Price/Tenkan Sen Buy");
         if(PTDNBuffer[i]>0)
            Alert(Symbol()+" "+timeframeToString(Period())+" "+short_name+" Signal: Price/Tenkan Sen Sell");
        }
      
      // signal 5
      if(ShowPriceKijunSenCross_5)
        {
         if(PKUPBuffer[i]>0)
            Alert(Symbol()+" "+timeframeToString(Period())+" "+short_name+" Signal: Price/Kijun Sen Buy");
         if(PKDNBuffer[i]>0)
            Alert(Symbol()+" "+timeframeToString(Period())+" "+short_name+" Signal: Price/Kijun Sen Sell");
        }
      
      // signal 6
      if(ShowPriceCloudCross_6)
        {
         if(PCUPBuffer[i]>0)
            Alert(Symbol()+" "+timeframeToString(Period())+" "+short_name+" Signal: Price/Cloud Buy");
         if(PCDNBuffer[i]>0)
            Alert(Symbol()+" "+timeframeToString(Period())+" "+short_name+" Signal: Price/Cloud Sell");
        }
      
      // signal 7
      if(ShowTenkanSenKijunSenCross_7)
        {
         if(TKUPBuffer[i]>0)
            Alert(Symbol()+" "+timeframeToString(Period())+" "+short_name+" Signal: Tenkan Sen/Kijun Sen Buy");
         if(TKDNBuffer[i]>0)
            Alert(Symbol()+" "+timeframeToString(Period())+" "+short_name+" Signal: Tenkan Sen/Kijun Sen Sell");
        }
      
      // signal 8
      if(ShowTenkanSenCloudCross_8)
        {
         if(TCUPBuffer[i]>0)
            Alert(Symbol()+" "+timeframeToString(Period())+" "+short_name+" Signal: Tenkan Sen/Cloud Buy");
         if(TCDNBuffer[i]>0)
            Alert(Symbol()+" "+timeframeToString(Period())+" "+short_name+" Signal: Tenkan Sen/Cloud Sell");
        }
      
      // signal 9
      if(ShowKijunSenCloudCross_9)
        {
         if(KCUPBuffer[i]>0)
            Alert(Symbol()+" "+timeframeToString(Period())+" "+short_name+" Signal: Kijun Sen/Cloud Buy");
         if(KCDNBuffer[i]>0)
            Alert(Symbol()+" "+timeframeToString(Period())+" "+short_name+" Signal: Kijun Sen/Cloud Sell");
        }
      
      // signal 10
      if(ShowSenkouSpanABCross_10)
        {
         if(SSABUPBuffer[i]>0)
            Alert(Symbol()+" "+timeframeToString(Period())+" "+short_name+" Signal: Senkou Span A/B Buy");
         if(SSABDNBuffer[i]>0)
            Alert(Symbol()+" "+timeframeToString(Period())+" "+short_name+" Signal: Senkou SPan A/B Sell");
        }
     }

//--- return value of prev_calculated for next call
   return(rates_total);
  }

//+------------------------------------------------------------------+
bool isNewBar()
  {
   bool res=false;

   if(iTime(NULL,0,0)!=pTime)
     {
      res=true;
      pTime=iTime(NULL,0,0);
     }

   return(res);
  }

//+------------------------------------------------------------------+
string timeframeToString(int timeframe)
  {
   switch(timeframe)
     {
      case PERIOD_M1       : return("M1"); //break;  
      case PERIOD_M2       : return("M2"); //break; 
      case PERIOD_M3       : return("M3"); //break; 
      case PERIOD_M4       : return("M4"); //break; 
      case PERIOD_M5       : return("M5"); //break;       
      case PERIOD_M6       : return("M6"); //break; 
      case PERIOD_M10      : return("M10"); //break; 
      case PERIOD_M12      : return("M12"); //break; 
      case PERIOD_M15      : return("M15"); //break; 
      case PERIOD_M20      : return("M20"); //break; 
      case PERIOD_M30      : return("M30"); //break; 
      case PERIOD_H1       : return("H1"); //break; 
      case PERIOD_H2       : return("H2"); //break; 
      case PERIOD_H3       : return("H3"); //break; 
      case PERIOD_H4       : return("H4"); //break; 
      case PERIOD_H6       : return("H6"); //break; 
      case PERIOD_H8       : return("H8"); //break; 
      case PERIOD_H12      : return("H12"); //break; 
      case PERIOD_D1       : return("D1"); //break; 
      case PERIOD_W1       : return("W1"); //break; 
      case PERIOD_MN1      : return("MN1"); //break;       
      default              : return("Current");
     }
  }
//+------------------------------------------------------------------+

double getChikouSpan(int index)
  {
    return iIchimoku(NULL,0,Tenkan,Kijun,Senkou,MODE_CHIKOUSPAN,index); 
    //return iCustom(NULL,0,"Price_Action_Ichimoku_Fibo_V2",0,Tenkan,Kijun,Senkou,4,index);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
double getTenkanSen(int index)
  {
    return iIchimoku(NULL,0,Tenkan,Kijun,Senkou,MODE_TENKANSEN,index);
    //return iCustom(NULL,0,"Price_Action_Ichimoku_Fibo_V2",0,Tenkan,Kijun,Senkou,0,index);

  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
double getKijunSen(int index)
  {
    return iIchimoku(NULL,0,Tenkan,Kijun,Senkou,MODE_KIJUNSEN,index);
    //return iCustom(NULL,0,"Price_Action_Ichimoku_Fibo_V2",0,Tenkan,Kijun,Senkou,1,index);

  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
double getSenkouSpanA(int index)
  {
    return iIchimoku(NULL,0,Tenkan,Kijun,Senkou,MODE_SENKOUSPANA,index); // Senkou Span A at time of latest closed bar of Chinkou span.
    //return iCustom(NULL,0,"Price_Action_Ichimoku_Fibo_V2",0,Tenkan,Kijun,Senkou,2,index);


  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
double getSenkouSpanB(int index)
  {
    return iIchimoku(NULL,0,Tenkan,Kijun,Senkou,MODE_SENKOUSPANB,index); // Senkou Span B at time of latest closed bar of Chinkou span.
    //return iCustom(NULL,0,"Price_Action_Ichimoku_Fibo_V2",0,Tenkan,Kijun,Senkou,3,index);


  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
double getSenkouSpanB_UP(int index)
  {
    return iIchimoku(NULL,0,Tenkan,Kijun,Senkou,MODE_SENKOUSPANB,index); // Senkou Span B at time of latest closed bar of Chinkou span.
    //return iCustom(NULL,0,"Price_Action_Ichimoku_Fibo_V2",0,Tenkan,Kijun,Senkou,7,index);


  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
double getSenkouSpanB_DN(int index)
  {
    return iIchimoku(NULL,0,Tenkan,Kijun,Senkou,MODE_SENKOUSPANB,index); // Senkou Span B at time of latest closed bar of Chinkou span.
    //return iCustom(NULL,0,"Price_Action_Ichimoku_Fibo_V2",0,Tenkan,Kijun,Senkou,8,index);


  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool checkCrossUP(double x1,double x0,double y1,double y0)
  {
   if(x1<=y1 && x0>y0 && x0>x1)
     {
      return true;
     }

   return false;

  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool checkCrossDN(double x1,double x0,double y1,double y0)
  {
   if(x1>=y1 && x0<y0 && x0<x1)
     {
      return true;
     }

   return false;
  }
//+------------------------------------------------------------------+

void SignalFilterUP(double &UP[],int i)
  {
   int signal_level=0x7FFFFFFF;

   if(UP[i]>0)
     {
      if(EnablePriceKumoConfirmation)
        {
         if(PKCBuffer[i]<0) signal_level=1;
         if(PKCBuffer[i]==0) signal_level=2;
         if(PKCBuffer[i]>0) signal_level=3;
        }

      if(EnableChikouSpanPriceConfirmation)
        {

         if(signal_level==0x7FFFFFFF)
           {
            if(CPCBuffer[i]<0) signal_level=1;
            if(CPCBuffer[i]==0) signal_level=2;
            if(CPCBuffer[i]>0) signal_level=3;

           }
         else
           {
            if(CPCBuffer[i]<0) signal_level--;
            if(CPCBuffer[i]>0) signal_level++;
           }

        }
      if(signal_level<Signal_Filter_Level)
         UP[i]=0;

     }

   return;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void SignalFilterDN(double &DN[],int i)
  {
   int signal_level=0x7FFFFFFF;

   if(DN[i]>0)
     {

      if(EnablePriceKumoConfirmation)
        {
         if(PKCBuffer[i]<0) signal_level=3;
         if(PKCBuffer[i]==0) signal_level=2;
         if(PKCBuffer[i]>0) signal_level=1;
        }

      if(EnableChikouSpanPriceConfirmation)
        {

         if(signal_level==0x7FFFFFFF)
           {
            if(CPCBuffer[i]>0) signal_level=1;
            if(CPCBuffer[i]==0) signal_level=2;
            if(CPCBuffer[i]<0) signal_level=3;

           }
         else
           {
            if(CPCBuffer[i]>0) signal_level--;
            if(CPCBuffer[i]<0) signal_level++;
           }
        }
      if(signal_level<Signal_Filter_Level)
         DN[i]=0;

     }

   return;
  }
//+------------------------------------------------------------------+
