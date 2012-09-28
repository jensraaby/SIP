function varargout = gammatool(varargin)
% GAMMATOOL MATLAB code for gammatool.fig
%      GAMMATOOL, by itself, creates a new GAMMATOOL or raises the existing
%      singleton*.
%
%      H = GAMMATOOL returns the handle to a new GAMMATOOL or the handle to
%      the existing singleton*.
%
%      GAMMATOOL('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in GAMMATOOL.M with the given input arguments.
%
%      GAMMATOOL('Property','Value',...) creates a new GAMMATOOL or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before gammatool_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to gammatool_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help gammatool

% Last Modified by GUIDE v2.5 26-Sep-2012 21:06:04

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @gammatool_OpeningFcn, ...
                   'gui_OutputFcn',  @gammatool_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if (nargin < 1)
    error('Specify an image as input');
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT


% --- Executes just before gammatool is made visible.
function gammatool_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to gammatool (see VARARGIN)

% Load the image from the arguments
handles.origImage = varargin{1};
handles.currentImage = handles.origImage;
axes(handles.imageAxes);
imshow(handles.currentImage);
axes(handles.histAxes);
imhist(handles.currentImage);
% Set the current data value.
% handles.current_data = handles.peaks;
% surf(handles.current_data)


% Choose default command line output for gammatool
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes gammatool wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = gammatool_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on slider movement.
function tag_gammaslider_Callback(hObject, eventdata, handles)
% hObject    handle to tag_gammaslider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
newGamma = logconvert(get(hObject,'Value'));
newImage = gammaTransform(handles.origImage,newGamma);
imshow(handles.imageAxes,newImage);%,'Parent',handles.imageAxes);
axes(handles.histAxes);
imhist(newImage);
% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider


% --- Executes during object creation, after setting all properties.
function tag_gammaslider_CreateFcn(hObject, eventdata, handles)
% hObject    handle to tag_gammaslider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on slider movement.
function gammaSlider_Callback(hObject, eventdata, handles)
% hObject    handle to gammaSlider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Convert the linear slider scale to logarithmic
newGamma = logconvert(get(hObject,'Value'));
% Compute gamma transform of image
newImage = gammaTransform(handles.origImage,newGamma);
axes(handles.imageAxes);
imshow(newImage);
axes(handles.histAxes);
imhist(newImage);
gammaString = sprintf('Gamma = %0.5f',newGamma);
set(handles.gammaVal,'String',gammaString);

% --- Executes during object creation, after setting all properties.
function gammaSlider_CreateFcn(hObject, eventdata, handles)
% hObject    handle to gammaSlider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


function converted = logconvert( inputVal )
% LOGCONVERT Take a linear input value INPUTVAL and return 10^INPUTVAL
    converted = 10^inputVal;
    
function image_ = gammaTransform( image, gamma )
% GAMMATRANSFORM Takes an IMAGE and a GAMMA value and returns the
% transformed image.
    image_ = im2double(image); % One could also use rangeTransform 0 1 here
    image_ = image_ .^ gamma;

