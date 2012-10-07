function varargout = interactiveEdgeDetector(varargin)
% INTERACTIVEEDGEDETECTOR MATLAB code for interactiveEdgeDetector.fig
%      INTERACTIVEEDGEDETECTOR, by itself, creates a new INTERACTIVEEDGEDETECTOR or raises the existing
%      singleton*.
%
%      H = INTERACTIVEEDGEDETECTOR returns the handle to a new INTERACTIVEEDGEDETECTOR or the handle to
%      the existing singleton*.
%
%      INTERACTIVEEDGEDETECTOR('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in INTERACTIVEEDGEDETECTOR.M with the given input arguments.
%
%      INTERACTIVEEDGEDETECTOR('Property','Value',...) creates a new INTERACTIVEEDGEDETECTOR or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before interactiveEdgeDetector_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to interactiveEdgeDetector_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help interactiveEdgeDetector

% Last Modified by GUIDE v2.5 06-Oct-2012 12:06:18

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @interactiveEdgeDetector_OpeningFcn, ...
                   'gui_OutputFcn',  @interactiveEdgeDetector_OutputFcn, ...
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

if (nargin < 1)
    error('Specify an image as input!');
end

% --- Executes just before interactiveEdgeDetector is made visible.
function interactiveEdgeDetector_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to interactiveEdgeDetector (see VARARGIN)

% Choose default command line output for interactiveEdgeDetector
handles.output = hObject;

% Load the image from the arguments
handles.origImage = mirrorpadding(varargin{1});
handles.M = size(varargin{1},1);
handles.N = size(varargin{1},2);
handles.sigmaXVal = 0.5;
handles.sigmaYVal = 0.5;
handles.thresholdVal = 0.5;
if nargin > 1
    handles.type = varargin{2};
else
    handles.type = 'basic';
end
axes(handles.origimg);
imshow(varargin{1});
rerenderEdges(handles);

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes interactiveEdgeDetector wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = interactiveEdgeDetector_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;
% varargout{1} = handles.sigmaXVal;
% varargout{2} = handles.sigmaYVal;
% varargout{3} = handles.thresholdVal;

% --- Executes on slider movement.
function SigmaX_Callback(hObject, eventdata, handles)
% hObject    handle to SigmaX (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
handles.sigmaXVal = get(hObject,'Value');
sigxText = sprintf('Sigma (X): %2f',get(hObject,'Value'));
set(handles.sigmaxtext,'String',sigxText);
rerenderEdges(handles);


% --- Executes during object creation, after setting all properties.
function SigmaX_CreateFcn(hObject, eventdata, handles)
% hObject    handle to SigmaX (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end
set(gcbo,'value',0.5);
handles.SigmaX=gcbo;
% -or vice versa

% --- Executes on slider movement.
function SigmaY_Callback(hObject, eventdata, handles)
% hObject    handle to SigmaY (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
handles.sigmaYVal = get(hObject,'Value');
sigyText = sprintf('Sigma (Y): %2f',get(hObject,'Value'));
set(handles.sigmaytext,'String',sigyText);
rerenderEdges(handles);

% --- Executes during object creation, after setting all properties.
function SigmaY_CreateFcn(hObject, eventdata, handles)
% hObject    handle to SigmaY (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
set(gcbo,'value',0.5);
handles.SigmaY=gcbo;
% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on slider movement.
function threshold_Callback(hObject, eventdata, handles)
% hObject    handle to threshold (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
handles.thresholdVal = get(hObject,'Value');
threshText = sprintf('Threshold: %2f',get(hObject,'Value'));
set(handles.thresholdtext,'String',threshText);
rerenderEdges(handles);

% --- Executes during object creation, after setting all properties.
function threshold_CreateFcn(hObject, eventdata, handles)
% hObject    handle to threshold (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
set(gcbo,'value',0.5);
handles.threshold=gcbo;
% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


function rerenderEdges(handles)
    axes(handles.edgeimg);
    edged = edgedetector(handles.origImage,handles.sigmaXVal,handles.sigmaYVal,handles.thresholdVal,handles.type);
    imshow(edged(1:handles.M,1:handles.N));
