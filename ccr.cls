% ccr.cls
% Template for CCR Articles (very WIP)
% 2023 Wouter van Atteveldt

\ProvidesClass{ccr}[2023-02-03 v0.01]
\NeedsTeXFormat{LaTeX2e}

\LoadClass[twoside]{article}

%%%%%%%%%%%%% OVRERALL PAGE LAYOUT %%%%%%%%%%%%%%%%%%%
\RequirePackage[papersize={6.53in,9.61in},
  left=1.1in,right=1.1in,top=1in,textheight=7.25in]{geometry}

\usepackage[proportional,scaled=1]{erewhon}
\usepackage[english]{babel}
\RequirePackage[protrusion=true,expansion=true,final,babel]{microtype}

\linespread{1.1}

%%%%%%%%%%%%%% Information from authors %%%%%%%%%%%%%%%%%%%%%
\RequirePackage{ifthen}

\def\@shorttitle{}
\newcommand{\shorttitle}[1]{\def\@shorttitle{#1}}
\newcommand{\show@shorttitle}{%
  \ifthenelse{\equal{\@shorttitle}{}}%
  {\MakeLowercase{\@title}}{\MakeLowercase{\@shorttitle}}%
}

\def\@abstract{(specify abstract using \textbackslash abstract in preamble)}
\renewcommand{\abstract}[1]{\def\@abstract{#1}}
\newcommand{\show@abstract}{\@abstract}

\def\@keywords{(specify keywords using \textbackslash keywords in preamble)}
\newcommand{\keywords}[1]{\def\@keywords{#1}}
\newcommand{\show@keywords}{\@keywords}

\def\@shortauthors{etal}
\newcommand{\shortauthors}[1]{\def\@shortauthors{#1}}
\newcommand{\show@shortauthors}{\@shortauthors}

\def\@volume{X}
\newcommand{\volume}[1]{\def\@volume{#1}}
\newcommand{\show@volume}{\@volume}
\def\@pubnumber{Y}
\newcommand{\pubnumber}[1]{\def\@pubnumber{#1}}
\newcommand{\show@pubnumber}{\@pubnumber}
\def\@pubyear{20xx}
\newcommand{\pubyear}[1]{\def\@pubyear{#1}}
\newcommand{\show@pubyear}{\@pubyear}
\def\@doi{10.5117/ccr20xx.xxx.xxxx}
\newcommand{\doi}[1]{\def\@doi{#1}}
\newcommand{\show@doi}{\@doi}


\newcommand{\firstpage}[1]{\setcounter{page}{#1}}

%%%%%%%%%%%%%% HEADER / FOOTER %%%%%%%%%%%%%%%%%%%%%%%%
\RequirePackage{lastpage}
\RequirePackage{fancyhdr}
\RequirePackage{graphicx}
\newcommand{\smallcaps}[1]{\textsc{\footnotesize #1}}
\newcommand{\smallcapsl}[1]{\MakeLowercase{\smallcaps{#1}}}
\setlength{\headheight}{24pt}

\fancypagestyle{firstpage}{%
\fancyhf{} % clear all six fields
\fancyhead[L]{\includegraphics[height=2em]{aup.png}}
\fancyhead[R]{\smallcaps{computational communication research 
               \oldstylenums{\show@volume}.\oldstylenums{\show@pubnumber} (\oldstylenums{\show@pubyear}) 
               \oldstylenums{\thepage}--\oldstylenums{\pageref{LastPage}}\vspace{-.3em}\\
               \scriptsize\MakeUppercase{\sc\url{https://doi.org/\show@doi}}}}
\fancyfoot[L]{\footnotesize© \show@shortauthors. \vspace{-.3em}\\ This is an open access article distributed under the \href{https://creativecommons.org/licenses/by/4.0/}{\textsc{cc by} \oldstylenums{4.0} license}}
\fancyfoot[R]{\smallcaps{\thepage}}
\renewcommand{\headrulewidth}{0pt}
\renewcommand{\footrulewidth}{0pt}
}
\fancypagestyle{followingpage}{%
\fancyhf{} % clear all six fields

\fancyhead[RE]{\smallcaps{\show@shorttitle}}
%\fancyfoot[RE]{\smallcapsl{\show@shortauthors}}
\fancyhead[LO]{\smallcapsl{Computational Communication Research}}
\fancyfoot[LO,RE]{\smallcaps{\thepage}}
%\fancyfoot[LE]{\smallcapsl{\show@shorttitle}}
\fancyfoot[LE]{\smallcapsl{\show@shortauthors}}
%\fancyfoot[LE]{\MakeLowercase{\smallcaps{\show@shorttitle}}}
\fancyfoot[RO]{\smallcaps{vol.  \oldstylenums{\show@volume}, no.  \oldstylenums{\show@pubnumber},  \oldstylenums{\show@pubyear}}}
\renewcommand{\headrulewidth}{0Pt}
\renewcommand{\footrulewidth}{0pt}
}

\pagestyle{followingpage}
\AtBeginDocument{\thispagestyle{firstpage}}
%%%%%%%%%%%%%%%%%% Other markup / styling %%%%%%%%%%%%%%%%%%%%%

% More compact enumerations
\renewcommand{\@listI}{%
  \itemsep=0\parsep}
% Bibliography style

%%%%%%%%%%%%% Author information  black magic %%%%%%%%%%%%%%%%%
% Mostly stolen from https://github.com/dan-weiss/apa7-latex-cls-source/blob/62f31e0b2c8c75e260a7690928c745d803333549/apa7/apa7.dtx (LPPL licensed)

\newcommand*\listauthors{}
\newcommand*\listsuperscripts{}
\newcommand*\listaffiliations{}

\newcommand*{\authorsnames}[2][]{
  \def\def@multipleauthors{\@multipleauthorsmode} %
  \renewcommand*\listauthors{}
  \renewcommand*\listsuperscripts{}
  \newcounter{NumberOfAuthors}
  \newcounter{NumberOfSuperscripts}
  \forcsvlist{\stepcounter{NumberOfAuthors}\listadd\listauthors}{#2}
  \forcsvlist{\stepcounter{NumberOfSuperscripts}\listadd\listsuperscripts}{#1}
  }
  
\newcommand*{\authorsaffiliations}[1]{
  \def\def@multipleaffils{\@multipleaffilsmode} %
  \renewcommand*\listaffiliations{}
  \newcounter{NumberOfAffiliations}
  \forcsvlist{\stepcounter{NumberOfAffiliations}\listadd\listaffiliations}{#1}
  }
  
\catcode`\|=3
  
\def\looptwo#1#2{%
    \edef\tmp{\noexpand\xtwo%
      \unexpanded\expandafter{#1}\relax  % no added delimiter here
      \unexpanded\expandafter{#2}\relax  % no added delimiter here
    } \tmp%
  }%
  
\def\xtwo#1|#2\relax#3|#4\relax{%
    \dotwo{#1}{#3}%
    \def\tmp{#2}%
    \ifx\empty\tmp%
      \expandafter\@gobble%
    \else%
      \expandafter\@firstofone%
    \fi%
    {\xtwo#2\relax#4\relax}%
  }%

  \catcode`\|=12
\newcommand*{\dotwo}[2]{}


%%%%%%%%%%%%%% Title page %%%%%%%%%%%%%%%%%%%%%
\RequirePackage{calc}
\RequirePackage{pstricks}
\RequirePackage{hyphenat}

\renewcommand{\maketitle}{%
\sloppy
\noindent{\fontsize{14}{13.5}\fontseries{b}\selectfont\raggedright\nohyphens{\@title}}
\vspace{.5in}

\fussy
\renewcommand*{\dotwo}[2]{%
\noindent##1\\
\noindent\textit{##2}
\vspace{1em}\par
}
\looptwo\listauthors\listaffiliations

\vspace{1em}
\parbox{\textwidth-\parindent-\parindent}{\small
\textbf{Abstract}\\\show@abstract
\\\\
\textbf{Keywords:} \show@keywords
}
}

%%%%%%%%%%%%%% Sections %%%%%%%%%%%%%%%%%%%%%
\renewcommand{\section}{%
\@startsection{section}{1}{0pt}%
{-1.5ex plus -1ex minus -.2ex}{2ex}%
{\fontsize{14}{13.5}\fontseries{b}\selectfont}%
}
\setcounter{secnumdepth}{0}


%%%%%%%%%%%%%% Reference handling %%%%%%%%%%%%%%%%%%%%%
\RequirePackage{csquotes}
\RequirePackage[style=apa,sortcites=true,sorting=nyt,backend=biber]{biblatex}

\DeclareLanguageMapping{american}{american-apa}

\renewcommand{\bibfont}{\small}
\setlength{\bibhang}{\parindent}






