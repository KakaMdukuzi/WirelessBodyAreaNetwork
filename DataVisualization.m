function varargout = GUI(varargin)

% EEG Open BCI Control UI 
% GUI MATLAB code for GUI.fig
%      GUI, by itself, creates a new GUI or raises the existing
%      singleton*.
%
%      H = GUI returns the handle to a new GUI or the handle to
%      the existing singleton*.
%f
%      GUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in GUI.M with the given input arguments.
%
%      GUI('Property','Value',...) creates a new GUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before GUI_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to GUI_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help GUI

% Last Modified by GUIDE v2.5 14-Nov-2018 22:04:52

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @GUI_OpeningFcn, ...
                   'gui_OutputFcn',  @GUI_outputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT


% --- Executes just before GUI is made visible.
function GUI_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no out(timeunit)put args, see out(timeunit)putFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to GUI (see VARARGIN)

% Choose default command line out(timeunit)put for GUI
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes GUI wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- out(timeunit)puts from this function are returned to the command line.
function varargout = GUI_outputFcn(hObject, eventdata, handles) 
% varargout(timeunit)  cell array for returning out(timeunit)put args (see VARARGout(timeunit));
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line out(timeunit)put from handles structure
varargout{1} = handles.output;



function buad_Callback(hObject, eventdata, handles)
global baudrate;

baudrate = str2double(get(hObject,'String'));
% hObject    handle to buad (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of buad as text
%        str2double(get(hObject,'String')) returns contents of buad as a double


% --- Executes during object creation, after setting all properties.
function buad_CreateFcn(hObject, eventdata, handles)
% hObject    handle to buad (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in comport.
function comport_Callback(hObject, eventdata, handles)
% hObject    handle to comport (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global content;
contents = cellstr(get(hObject,'String'));

if contents{get(hObject,'Value')}  == 'COM1'
    content = 'COM1';
elseif contents{get(hObject,'Value')} == 'COM2'
   content = 'COM2';
elseif contents{get(hObject,'Value')} == 'COM3'
   content = 'COM3';
elseif contents{get(hObject,'Value')} == 'COM4'
   content = 'COM4';
elseif contents{get(hObject,'Value')} == 'COM5'
   content = 'COM5';
elseif contents{get(hObject,'Value')} == 'COM6'
   content = 'COM6';
elseif contents{get(hObject,'Value')} == 'COM7'
   content = 'COM7';
elseif contents{get(hObject,'Value')} == 'COM8'
   content = 'COM8';
elseif contents{get(hObject,'Value')} == 'COM9'
   content = 'COM9';
elseif contents{get(hObject,'Value')} == 'COM10'
   content = 'COM10';
end



% Hints: contents = cellstr(get(hObject,'String')) returns comport contents as cell array
%        contents{get(hObject,'Value')} returns selected item from comport


% --- Executes during object creation, after setting all properties.
function comport_CreateFcn(hObject, eventdata, handles)
% hObject    handle to comport (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in open.
function open_Callback(hObject, eventdata, handles)
global content;
global baudrate; 
global serialConn;
serialConn = serial(content, 'BaudRate', baudrate , 'Terminator', 'CR', 'StopBit', 1, 'Parity', 'None');

fopen(serialConn);
% hObject    handle to open (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in close.
function close_Callback(hObject, eventdata, handles)
global content;
global baudrate; 
global serialConn;


fclose(serialConn);
% hObject    handle to close (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%%%%%%%%%%%%%%%%%%%%%% CODE FOR GRAPHS %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% --- Executes on button press in start.
function start_Callback(hObject, eventdata, handles)
% hObject    handle to start (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%axes(handles.ch1); % Switch current axes to ch11.
%plot(aplot(:,2)); % Will plot into axes1.
%grid on


t = 1:1000000;
timeunit =1
global serialConn;



axes(handles.ch1)

ax1 = animatedline;
axes(handles.ch2)

ax2 = animatedline;
axes(handles.ch3)

ax3 = animatedline;
axes(handles.ch4)

ax4 = animatedline;
axes(handles.ch5)

ax5 = animatedline;
axes(handles.ch6)

ax6 = animatedline;
axes(handles.ch7)

ax7 = animatedline;
axes(handles.ch8)

ax8 = animatedline;
axes(handles.ch9)

ax9 = animatedline;
axes(handles.ch10)

ax10 = animatedline;
axes(handles.ch11)

ax11 = animatedline;
axes(handles.ch12)

ax12 = animatedline;
axes(handles.ch13)

ax13 = animatedline;
axes(handles.ch14)

ax14 = animatedline;
axes(handles.ch15)

ax15 = animatedline;
axes(handles.ch16);

ax16 = animatedline;

s = figure('Name','ECG Graph','NumberTitle','off');
axes(s)
x = animatedline('Color', 'r');
yticks([])
axvector = [ax1, ax2, ax3, ax4, ax5, ax6, ax7, ax8, ax9, ax10, ax11, ax12, ax13, ax14, ax15, ax16,x];

%out = zeros(1,1000) * rand()*2;
while(1)
    out =fread(serialConn,17,'float');
   
    %disp(out(timeunit))
    for i=1:16
        addpoints(axvector(i),t(timeunit),out(i))
        drawnow update  
    end
    
    addpoints(axvector(17),t(timeunit),out(17));
    drawnow update
    timeunit = timeunit+1
    dlmwrite('MyDataFile.csv', out', 'delimiter', ',' ,'-append');
 end
 

 

