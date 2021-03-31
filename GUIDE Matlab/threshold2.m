function varargout = threshold2(varargin)
% THRESHOLD2 MATLAB code for threshold2.fig
%      THRESHOLD2, by itself, creates a new THRESHOLD2 or raises the existing
%      singleton*.
%
%      H = THRESHOLD2 returns the handle to a new THRESHOLD2 or the handle to
%      the existing singleton*.
%
%      THRESHOLD2('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in THRESHOLD2.M with the given input arguments.
%
%      THRESHOLD2('Property','Value',...) creates a new THRESHOLD2 or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before threshold2_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to threshold2_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help threshold2

% Last Modified by GUIDE v2.5 21-Mar-2021 12:55:52

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @threshold2_OpeningFcn, ...
                   'gui_OutputFcn',  @threshold2_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:})
end
% End initialization code - DO NOT EDIT


% --- Executes just before threshold2 is made visible.
function threshold2_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to threshold2 (see VARARGIN)

% Initialization
global gMode gOrigin gFullPath gNumOfFrames;
gMode = -1;
gOrigin = 0;
gNumOfFrames = 0;

% Choose default command line output for threshold2
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes threshold2 wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = threshold2_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in img_open.
function img_open_Callback(hObject, eventdata, handles)
% hObject    handle to img_open (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global gMode gOrigin gFullPath gNumOfFrames;

gMode = 0;
gOrigin = 0;
gNumOfFrames = 0;
[fileName, pathName] = uigetfile({'*.jpg;*.png;*.jpeg;*.bmp', 'Image (*.jpg,*.png,*.jpeg)';
                                  '*.*', 'All Files (*.*)'},...
                                  'Select an Image');
gFullPath = strcat(pathName, fileName);
try
    gOrigin = imread(gFullPath);
catch
    disp('Unable to open file!');
end
originShowFrame(handles, gOrigin);

resetState(handles);


%%%%%%%%%%Simple thresholding%%%%%%
% --- Executes on button press in simple_proc_btn.
function simple_proc_btn_Callback(hObject, eventdata, handles)
% hObject    handle to simple_proc_btn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global gMode gOrigin Simplethres simpleDone gNumOfFrames gFullPath;

if simpleDone == 0
    handles.gauss_proc_btn.String = 'Processing';
    if gMode == 0
        tic
           set(handles.slider1,'Value',0)
            Simplethres = rgb2gray(gOrigin);
            simpleDone = graythresh(Simplethres);
            bw = im2bw(Simplethres,simpleDone)
            axes(handles.simple_thres)
        eTime = toc;
        fprintf('Simple elapsed time: %.2f\n', eTime);
    end
end
    simpleDone = 1;
    handles.simple_proc_btn.String = 'Done';        

function simple_save_Callback(hObject, eventdata, handles)
% hObject    handle to simple_save (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global gMode Simplethres simpleDone gNumOfFrames;

if simpleDone == 0
    return;
end

if gMode == 0
    name = getSaveNameImg();
    if ~isempty(name)
        imwrite(Simplethres, name, 'jpg');
        disp('Simple write done!');
    end
end

% --- Executes on slider movement.
function slider1_Callback(hObject, eventdata, handles)
% hObject    handle to slider1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider


% --- Executes during object creation, after setting all properties.
global gMode gOrigin Simplethres simpleDone gNumOfFrames gFullPath;
if gMode == 0
    Simplethres = rgb2gray(gOrigin)
    simpleDone = get(hObject,'value');
    bw = im2bw(Simplethres,simpleDone)
    axes(handles.simple_thres)
    cla('reset')
    imshow(bw)
    axes(handles.simple_thres)
end



function slider1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end

function edit2_Callback(hObject, eventdata, handles)
% hObject    handle to edit2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit2 as text
%        str2double(get(hObject,'String')) returns contents of edit2 as a double


% --- Executes during object creation, after setting all properties.
function edit2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


%%%%%%%%%%%%%OTSU%%%%%%%%%%%%%%%%%%%%%
function global_proc_btn_Callback(hObject, eventdata, handles)
% hObject    handle to global_proc_btn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global gMode gOrigin globalRes globalDone gNumOfFrames gFullPath;

if globalDone == 0
    handles.global_proc_btn.String = 'Processing';
    if gMode == 0
        tic
        globalRes = OtsuBin(gOrigin);
        globalShowFrame(handles, globalRes);
        eTime = toc;
        fprintf('Otsu elapsed time: %.2f\n', eTime);
    end
    globalDone = 1;
    handles.global_proc_btn.String = 'Done';
end
% --- Executes on button press in global_save.
function global_save_Callback(hObject, eventdata, handles)
% hObject    handle to global_save (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global gMode globalRes globalDone gNumOfFrames;

if globalDone == 0
    return;
end

if gMode == 0
    name = getSaveNameImg();
    if ~isempty(name)
        imwrite(globalRes, name, 'jpg');
        disp('Global write done!');
    end
end


%%%%%%%%%%%%%%%%%%%%%%%Adaptive Mean%%%%%%%%%%%%
function gauss_proc_btn_Callback(hObject, eventdata, handles)
% hObject    handle to gauss_proc_btn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global gMode gOrigin gaussRes gaussDone gNumOfFrames gFullPath;

if gaussDone == 0
    handles.gauss_proc_btn.String = 'Processing';
    if gMode == 0
        tic
        gaussRes = adaptivethreshold(gOrigin, 15, 0.025);
        gaussShowFrame(handles, gaussRes);
        eTime = toc;
        fprintf('Gauss elapsed time: %.2f\n', eTime);
    end
    gaussDone = 1;
    handles.gauss_proc_btn.String = 'Done';
end

% --- Executes on button press in gauss_save.
function gauss_save_Callback(hObject, eventdata, handles)
% hObject    handle to gauss_save (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global gMode gaussRes gaussDone gNumOfFrames;

if gaussDone == 0
    return;
end

if gMode == 0
    name = getSaveNameImg();
    if ~isempty(name)
        imwrite(gaussRes, name, 'jpg');
        disp('Gauss write done!');
    end
end

function bw=adaptivethreshold(IM,ws,C,tm)
% ADAPTIVETHRESHOLD An adaptive thresholding algorithm that seperates the
% foreground from the background with nonuniform illumination.
% bw=adaptivethreshold(IM,ws,C) outputs a binary image bw with the local 
% threshold2 mean-C or median-C to the image IM.
% ws is the local window size.
% tm is 0 or 1, a switch between mean and median. tm=0 mean(default); tm=1 median.
 
if (nargin < 3)
    error('You must provide the image IM, the window size ws, and C.');
elseif (nargin == 3)
    tm = 0;
elseif (tm ~= 0 && tm ~= 1)
    error('tm must be 0 or 1.');
end
 
IM = mat2gray(IM);
 
if tm == 0
    mIM = imfilter(IM,fspecial('average', ws), 'replicate');
else
    mIM = medfilt2(IM, [ws ws]);
end
sIM = mIM - IM - C;
bw = im2bw(sIM, 0);
bw = imcomplement(bw);
% bw = bw * 255;
% bw = uint8(bw);


%%%%%%%%%%%%Adaptive mean using integral image%%%%%
% --- Executes on button press in int_proc_btn_Callback.
function int_proc_btn_Callback(hObject, eventdata, handles)
% hObject    handle to int_proc_btn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global gMode gOrigin intRes intDone gNumOfFrames gFullPath;

if intDone == 0
    handles.int_proc_btn.String = 'Processing';
    if gMode == 0
        tic
        intRes = bradley(img2grayT(gOrigin), [15 15], 8);
        intShowFrame(handles, intRes);
        eTime = toc;
        fprintf('Integral elapsed time: %.2f\n', eTime);
    end
    intDone = 1;
    handles.int_proc_btn.String = 'Done';
end
% --- Executes on button press in int_save.
function int_save_Callback(hObject, eventdata, handles)
% hObject    handle to int_save (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global gMode intRes intDone gNumOfFrames;

if intDone == 0
    return;
end

if gMode == 0
    name = getSaveNameImg();
    if ~isempty(name)
        imwrite(intRes, name, 'jpg');
        disp('Integral write done!');
    end
end


function originShowFrame(handles, frame)

axes(handles.original);
imshow(frame);

function gaussShowFrame(handles, frame)
axes(handles.adap_mean);
imshow(logical(frame));

function intShowFrame(handles, frame)
axes(handles.adap_int);
imshow(logical(frame));

function globalShowFrame(handles, frame)
axes(handles.otsu_thres);
imshow(logical(frame));

function resetState(handles)
global gaussDone globalDone intDone;
    gaussDone = 0;
    globalDone = 0;
    intDone = 0;
    simpleDone = 0;

    handles.gauss_proc_btn.String = 'Process';
    handles.global_proc_btn.String = 'Process';
    handles.int_proc_btn.String = 'Process';
    handles.simple_proc_btn.String = 'Process';

function name = getSaveNameImg()
    filter = {'*.jpg', 'Image (*.jpg)'; '*.*', 'All Files (*.*)'};
    [file, path] = uiputfile(filter, 'Save File');
    name = strcat(path, file);

function res = img2grayT(img)
    res = img;
    try
        res = rgb2gray(img);
    catch
        disp('Not RGB');
    end

function res = OtsuBin(img)
    img = img2grayT(img);
    level = graythresh(img);
    res = imbinarize(img, level);
