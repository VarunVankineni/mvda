function status = matlab2tex(mfile,varargin)
% function status = publish2pdf(mfile,varargin)
%  Writes a file with tex for syntax colored listing of matlab code in mfile
%  an example of how to include tex in Lyx: 
%  Paste into Document preamble (without matlab comments, of course)
%      \usepackage{alltt}
%      \usepackage{color}
%      \definecolor{string}{rgb}{0.7,0.0,0.0}
%      \definecolor{comment}{rgb}{0.13,0.54,0.13}
%      \definecolor{keyword}{rgb}{0.0,0.0,1.0}
%  Insert a float figure
%  Click in figure, start an insert ERT (ctrl-L)
%  Do Insert|file|plain text and navigate to tex file
%  click outside ERT
%  ---
%  inputs: 
%    mfile: the m-file path and name. If no path is specified, looks in matlab working dir 
%    linenumbers: (optional = false) If present, includes linenumbers in listing
%  outputs:
%    creates a file mfilename.tex in same dir as original matlabfile
%    status: the last 'status' from the file open/close commands. 0 if executed without errors
%  REA 5/11/09

  % process the optional arguments
nreqargs = 1;
linenumbers= false;

if(nargin>nreqargs)
  i=1;
  while(i<=size(varargin,2))
     switch lower(varargin{i})
     case 'linenumbers';          linenumbers=true;
    otherwise
      error('Unknown argument %s given',varargin{i});
     end
     i=i+1;
  end
end

    % options for highlight function
opt.type = 'tex';
opt.linenb = linenumbers; 

     % get the directory and file name 
[pathstr, name, ext] = fileparts(mfile);
pathfull = [pathstr filesep];
mfile_name_with_path = [pathfull name]; % no extension
mfile_name = [name ext];

     % create a file pointer as input to highlight
texname =  [pathfull name '.tex'];
fid = fopen(texname,'wt');
if fid == 0
   error('could not open tex file %s',texname);
   status = 1;
end   
highlight(mfile,opt,fid);
status = fclose(fid);
