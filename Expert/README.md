# CExpert 
CExpert is a base class for trading strategies
#### Description
The CExpert class is a set of virtual methods for implementation of trading strategies
#### Title
    #include <mql5-lib\Expert\CExpert.mqh>
#### Declaration
    class CExpert : public CObject
#### Inheritance hierarchy
[CObject](https://www.mql5.com/en/docs/standardlibrary/cobject) > CExpert 

## Public/Protected Methods
### Routines
| Method | Description |
|--|--|
| Init | Class instance initialization method |
| virtual InitIndicators | Initializes indicators |
| virtual InitVars | Initializes vars |
| DeInit | Class instance deinitialization method |
| virtual DeInitIndicators | DeInitializes indicators |
| virtual DeInitVars | DeInitializes vars |
| Tick | Class instance tick method |
| virtual ValidateSettings | Checks the settings |
### Parameters
| Method | Description |
|--|--|
| Timeframe | Timeframe of the expert |
### Events
| Method | Description |
|--|--|
| OnInit | Event called on Init method |
| OnDeInit | Event called on DeInit method |
| OnTick | Event called on Open method |
| OnError | Event called on InitIndicators method |
| OnOpen | Event called on Open method |
| OnCheckOpenCondition| Event called on CheckOpenCondition method |
| OnClose | Event called on Close method |
| OnCheckCloseCondition| Event called on CheckCloseCondition method |
| OnLoss | Event called ater Close method if profit is lower than 0 |
| OnProfit | Event called ater Close method if profit is higher than 0 |
| OnNewBar | Event called when a new bar is detected |
| OnNewDay | Event called on first bar of every day |
### Market
| Method | Description |
|--|--|
| virtual OpenLongCondition | Conditions to open a long position |
| virtual OpenShortCondition | Conditions to open a short position |
| virtual CloseCondition | Conditions to close any position |
| virtual CloseShortCondition | Conditions to close a short position |
| virtual CloseLongCondition | Conditions to close a long position |
### Market Parameters
| Method | Description |
|--|--|
| virtual OpenParameters | Set parameters to a new position |

## Enums / Consts
### M_STATES
| Property|
|--|
| STATE_RUNNING |
| STATE_OUT |
| STATE_ERROR |
### M_TICK_MODES
| Property|
|--|
| MODE_EVERYTICK |
| MODE_ NEWBAR |
