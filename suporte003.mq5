//+------------------------------------------------------------------+
//|                                                   suporte003.mq5 |
//|                        Copyright 2018, MetaQuotes Software Corp. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2018, MetaQuotes Software Corp."
#property link      "https://www.mql5.com"
#property version   "1.00"
#property indicator_chart_window
#property indicator_buffers 10
#property indicator_plots   10 

#include <Generic\ArrayList.mqh>
#include <ChartObjects\ChartObjectsLines.mqh>


CChartObjectHLine horizontalLine1;
CChartObjectHLine horizontalLine2;
CChartObjectHLine horizontalLine3;


class Preco {
    protected:
        int  valor;
        int  qnt;

    public:
        void Preco(int v, int q){
            valor = v;
            qnt = q;
        }

        int getValor(){
            return valor;
        }
    
        int getQnt(){
            return qnt;
        }
      
        void incQnt(){
            qnt++;
        }
};

template<typename T>
class Comparador : public IComparer<T>{
    public:
        Comparador(void){}
        ~Comparador(void){}
        
        int Compare(T x, T y){
            if(x.getQnt() < y.getQnt()){
                return -1;
            }
                 
            if(x.getQnt() > y.getQnt()){
                return 1;
            }
                 
            return 0;
        }
};

CArrayList<Preco*>* lista = new CArrayList<Preco*>();
Comparador<Preco*> comparador;

MqlRates historicoPrecos[];

//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int OnInit()
  {
   Print("OLAAAA MUNDO");
  
   ArraySetAsSeries(historicoPrecos, true);
   
   CopyRates(_Symbol, _Period, 0, 110, historicoPrecos);

   for(int i = 0; i < 102; i++){
      for(int j = (int)historicoPrecos[i].low; j <= historicoPrecos[i].high; j+=5){
         Preco* aux;
         int inseriu = 0;
         
         for(int k = 0; k < lista.Count(); k++){
            lista.TryGetValue(k, aux);
            
            if(aux.getValor() == j){
               aux.incQnt();
               inseriu = 1;
            }    
         }
         
         if(inseriu == 0){
            lista.Add(new Preco(j, 1));
         }
      }
   }  
    
   lista.Sort(&comparador);
   
   Preco* aux;
   
   for(int k = 0; k < lista.Count(); k++){
      lista.TryGetValue(k, aux);
      Print("Array[", k, "]: ", aux.getValor(), "(", aux.getQnt(), ")");
   }
 
//--- indicator buffers mapping
   horizontalLine1.Create(0, "LINHA 1", 0, 70110);
   horizontalLine1.SetInteger(OBJPROP_COLOR, clrBlue);
   horizontalLine1.SetInteger(OBJPROP_STYLE, STYLE_SOLID);
   horizontalLine1.SetInteger(OBJPROP_WIDTH, 1);
   
   horizontalLine2.Create(0, "LINHA 2", 0, 70210);
   horizontalLine2.SetInteger(OBJPROP_COLOR, clrBlue);
   horizontalLine2.SetInteger(OBJPROP_STYLE, STYLE_SOLID);
   horizontalLine2.SetInteger(OBJPROP_WIDTH, 1);
   
   horizontalLine3.Create(0, "LINHA 3", 0, 70310);
   horizontalLine3.SetInteger(OBJPROP_COLOR, clrBlue);
   horizontalLine3.SetInteger(OBJPROP_STYLE, STYLE_SOLID);
   horizontalLine3.SetInteger(OBJPROP_WIDTH, 1);
   
//---
   return(INIT_SUCCEEDED);
  }
//+------------------------------------------------------------------+
//| Custom indicator iteration function                              |
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
//---


   
//--- return value of prev_calculated for next call
   return(rates_total);
  }
//+------------------------------------------------------------------+
//| Timer function                                                   |
//+------------------------------------------------------------------+
void OnTimer()
  {
//---
   
  }
//+------------------------------------------------------------------+
