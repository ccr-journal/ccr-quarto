% Template for CCR Articles (very WIP)
% 2023 Wouter van Atteveldt, Damian Trilling, Chung-hong Chan, Johannes B. Gruber
% Version 0.10
% Please see https://github.com/ccr-journal/ccr-quarto for the latest version of this file

\ProvidesClass{ccr}[2026-05-13 v0.10]
\NeedsTeXFormat{LaTeX2e}

\newif\if@review
\@reviewfalse
\newif\if@loadbiblatex
\@loadbiblatextrue

\DeclareOption{review}{\@reviewtrue}
\DeclareOption{nobib}{\@loadbiblatexfalse}
\ProcessOptions\relax

\RequirePackage{ifxetex}
\ifxetex\else
  \pdfminorversion=7
\fi
\LoadClass[twoside]{article}

%%%%%%%%%%%%% OVRERALL PAGE LAYOUT %%%%%%%%%%%%%%%%%%%
\RequirePackage[papersize={6.53in,9.61in},
  left=1.1in,right=1.1in,top=1in,textheight=7.25in]{geometry}

\RequirePackage{graphicx}

\RequirePackage[english]{babel}
\renewcommand*\oldstylenums[1]{\textosf{#1}}
\ifxetex
  \RequirePackage[protrusion=true,final,babel]{microtype}
  \RequirePackage{fontspec}
  \setmainfont{erewhon}  
  \setsansfont{Noto Sans}
  \usepackage{unicode-math}
  \defaultfontfeatures{ Scale=MatchLowercase, Ligatures=TeX }
  \setmathfont{Erewhon-Math.otf}

\else
  \RequirePackage[protrusion=true,expansion=true,final,babel]{microtype}
  \RequirePackage[sfdefault,scaled=.9]{noto}
  \RequirePackage[proportional,scaled=1]{erewhon}
  \RequirePackage[erewhon,vvarbb,bigdelims]{newtxmath}
\fi
\renewcommand{\floatpagefraction}{.7}
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

% Acknowledgements: renders an unnumbered Acknowledgements section in the PDF,
% suppressed in review mode to avoid de-anonymization. In LaTeXML the binding
% in ccr.cls.ltxml overrides this to emit <ltx:acknowledgements>, which lands
% in JATS <back><ack>.
\newcommand{\acknowledgements}[1]{%
  \if@review\else
    \section*{Acknowledgements}#1%
  \fi
}

% Supplementary material: pass-through stub so authors can already tag the
% section semantically; a future LaTeXML binding will route this to JATS
% <sec sec-type="supplementary-material"> (see issue #3).
\newcommand{\supplementarymaterial}[1]{#1}

\if@review
  \def\@shortauthors{Anonymous}
  % Does nothing in review mode, but is needed elsewhere
  \newcommand{\shortauthors}[1]{} 
  
  \def\@volume{}
  \newcommand{\volume}[1]{}
  
  \def\@pubnumber{}
  \newcommand{\pubnumber}[1]{}
  
  \def\@pubyear{}
  \newcommand{\pubyear}[1]{}
  
  \def\@doi{}
  \newcommand{\doi}[1]{}

  \def\@datereceived{}
  \newcommand{\datereceived}[1]{}

  \def\@dateaccepted{}
  \newcommand{\dateaccepted}[1]{}

  \def\@datepublished{}
  \newcommand{\datepublished}[1]{}
\else
  \def\@shortauthors{(please specify \textbackslash shortauthors)}
  \newcommand{\shortauthors}[1]{\def\@shortauthors{#1}}
  
  \def\@volume{X}
  \newcommand{\volume}[1]{\def\@volume{#1}}
  
  \def\@pubnumber{Y}
  \newcommand{\pubnumber}[1]{\def\@pubnumber{#1}}

  \def\@pubyear{20xx}
  \newcommand{\pubyear}[1]{\def\@pubyear{#1}}
  
  \def\@doi{}
  \newcommand{\doi}[1]{\def\@doi{#1}}

  \def\@datereceived{}
  \newcommand{\datereceived}[1]{\def\@datereceived{#1}}

  \def\@dateaccepted{}
  \newcommand{\dateaccepted}[1]{\def\@dateaccepted{#1}}

  \def\@datepublished{}
  \newcommand{\datepublished}[1]{\def\@datepublished{#1}}
\fi
\newcommand{\show@shortauthors}{\@shortauthors}
\newcommand{\show@volume}{\@volume}
\newcommand{\show@pubnumber}{\@pubnumber}
\newcommand{\show@pubyear}{\@pubyear}
\newcommand{\show@doi}{\@doi}
\newcommand{\show@datereceived}{\@datereceived}
\newcommand{\show@dateaccepted}{\@dateaccepted}
\newcommand{\show@datepublished}{\@datepublished}


\newcommand{\firstpage}[1]{\setcounter{page}{#1}}

%%%%%%%%%%%%%% HEADER / FOOTER %%%%%%%%%%%%%%%%%%%%%%%%
\RequirePackage{lastpage}
\RequirePackage{fancyhdr}

\newcommand{\smallcaps}[1]{\textsc{\footnotesize #1}}
\newcommand{\smallcapsl}[1]{\MakeLowercase{\smallcaps{#1}}}
\setlength{\headheight}{24pt}

%\usepackage{showframe} % useful for debugging header / margin
\fancypagestyle{firstpage}{%
\fancyhf{} % clear all six fields
\if@review
\else
  \fancyhead[L]{\includegraphics[height=2em]{aup_logo.pdf}}
\fi
\if@review
  \fancyhead[R]{\raisebox{.1em}{\smallcaps{computational communication research---manuscript}}}
\else
  \fancyhead[R]{\raisebox{.1em}{\smallcaps{computational communication research 
                 \oldstylenums{\show@volume}.\oldstylenums{\show@pubnumber} (\oldstylenums{\show@pubyear}) 
                 \oldstylenums{\thepage}--\oldstylenums{\pageref{LastPage}}}}%
                 \\%
                 \ifdefempty{\@doi}{}{
                 \raisebox{.4em}{\scriptsize\MakeUppercase{\sc\url{https://doi.org/\show@doi}}}
                 }}
\fi
\fancyfoot[RE,LO]{%
  \footnotesize© The author(s). This is an open access article distributed under the \href{https://creativecommons.org/licenses/by/4.0/}{\textsc{cc by} \oldstylenums{4.0} license}%
  \ifdefempty{\@datereceived}{}{%
    \\Manuscript received \show@datereceived, accepted \show@dateaccepted, published \show@datepublished%
  }%
}
\fancyfoot[LE,RO]{\smallcaps{\thepage}}
\renewcommand{\headrulewidth}{0pt}
\renewcommand{\footrulewidth}{0pt}
}
\fancypagestyle{followingpage}{%
\fancyhf{} % clear all six fields
\fancyhead[RE]{\smallcaps{\show@shorttitle}}
\fancyhead[LO]{\smallcapsl{Computational Communication Research}}
\fancyfoot[LE,RO]{\smallcaps{\thepage}}
\fancyfoot[LO]{\smallcapsl{\show@shortauthors}}
\if@review
  \fancyfoot[RE]{\smallcaps{unpublished manuscript}}
\else
  \fancyfoot[RE]{\smallcaps{vol. \oldstylenums{\show@volume}, no. \oldstylenums{\show@pubnumber}, \oldstylenums{\show@pubyear}}}
\fi

\renewcommand{\headrulewidth}{0Pt}
\renewcommand{\footrulewidth}{0pt}
}

\pagestyle{followingpage}
\AtBeginDocument{\thispagestyle{firstpage}}

%%%%%%%%%%%%%%%%%% Draft / review %%%%%%%%%%%%%%%%%%%%%%5

\if@review
    \RequirePackage[pagewise]{lineno}
    \RequirePackage{draftwatermark}
    \SetWatermarkText{\sffamily{For peer review}}
    \SetWatermarkScale{.5}
    \DraftwatermarkOptions{color={[RGB]{255,215,215}}}
    \setlength\linenumbersep{1cm}
\fi

%%%%%%%%%%%%%%%%%% Other markup / styling %%%%%%%%%%%%%%%%%%%%%
\RequirePackage{etoolbox}
% Tables
\AtBeginEnvironment{tabularx}{\footnotesize\sffamily}
\AtBeginEnvironment{tabular}{\footnotesize\sffamily}
\renewcommand{\arraystretch}{1.3}

\RequirePackage{makecell}
\renewcommand\theadfont{ \bfseries}
\renewcommand\theadalign{ll}
\usepackage[font={footnotesize,sf}]{caption}

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

%%%%%%%%%%%%% Label-based author / affiliation API (v0.09+) %%%%%%%%%%%%%%%%%%%
% New API: \addauthor[label1,label2]{Name} / \addaffiliation{label}[Dept]{Org}{CC}
% The legacy \authorsnames / \authorsaffiliations API above remains supported;
% \maketitle auto-detects which one is in use.

\RequirePackage{xparse}

% ISO 3166-1 alpha-2 country codes for affiliation validation.
% Reference: https://www.iso.org/iso-3166-country-codes.html
\newcommand*{\ccr@registeriso}[1]{%
  \expandafter\let\csname ccr@iso@#1\endcsname\@empty
}
\forcsvlist{\ccr@registeriso}{%
  AD,AE,AF,AG,AI,AL,AM,AO,AQ,AR,AS,AT,AU,AW,AX,AZ,
  BA,BB,BD,BE,BF,BG,BH,BI,BJ,BL,BM,BN,BO,BQ,BR,BS,BT,BV,BW,BY,BZ,
  CA,CC,CD,CF,CG,CH,CI,CK,CL,CM,CN,CO,CR,CU,CV,CW,CX,CY,CZ,
  DE,DJ,DK,DM,DO,DZ,
  EC,EE,EG,EH,ER,ES,ET,
  FI,FJ,FK,FM,FO,FR,
  GA,GB,GD,GE,GF,GG,GH,GI,GL,GM,GN,GP,GQ,GR,GS,GT,GU,GW,GY,
  HK,HM,HN,HR,HT,HU,
  ID,IE,IL,IM,IN,IO,IQ,IR,IS,IT,
  JE,JM,JO,JP,
  KE,KG,KH,KI,KM,KN,KP,KR,KW,KY,KZ,
  LA,LB,LC,LI,LK,LR,LS,LT,LU,LV,LY,
  MA,MC,MD,ME,MF,MG,MH,MK,ML,MM,MN,MO,MP,MQ,MR,MS,MT,MU,MV,MW,MX,MY,MZ,
  NA,NC,NE,NF,NG,NI,NL,NO,NP,NR,NU,NZ,
  OM,
  PA,PE,PF,PG,PH,PK,PL,PM,PN,PR,PS,PT,PW,PY,
  QA,
  RE,RO,RS,RU,RW,
  SA,SB,SC,SD,SE,SG,SH,SI,SJ,SK,SL,SM,SN,SO,SR,SS,ST,SV,SX,SY,SZ,
  TC,TD,TF,TG,TH,TJ,TK,TL,TM,TN,TO,TR,TT,TV,TW,TZ,
  UA,UG,UM,US,UY,UZ,
  VA,VC,VE,VG,VI,VN,VU,
  WF,WS,
  YE,YT,
  ZA,ZM,ZW%
}
% User-assigned code (not in ISO 3166-1) accepted as the de facto standard for
% Kosovo, used by the EU, IMF, World Bank, and SWIFT.
\forcsvlist{\ccr@registeriso}{XK}

% State for the new label-based API
\newif\if@ccr@newauthors
\newcounter{ccr@nauthors}
\newcommand*\ccr@affillabels{}

% \addauthor[label1,label2,...]{Name}
% At least one affiliation label is required.
\NewDocumentCommand{\addauthor}{O{} m}{%
  \edef\ccr@tmplabels{\detokenize{#1}}%
  \ifx\ccr@tmplabels\@empty
    \ClassError{ccr}{%
      \string\addauthor\space requires at least one affiliation label,
      e.g. \string\addauthor[uva]{Name}}%
      {Every author must declare at least one affiliation. Use
      \string\addaffiliation\space to declare an affiliation, then
      reference its label in the optional argument of \string\addauthor.}%
  \fi
  \@ccr@newauthorstrue
  \stepcounter{ccr@nauthors}%
  \expandafter\gdef\csname ccr@authorname@\number\value{ccr@nauthors}\endcsname{#2}%
  \expandafter\gdef\csname ccr@authorlabels@\number\value{ccr@nauthors}\endcsname{#1}%
}

% \addaffiliation{label}[Department]{University/Organisation}{ISO country code}
% Country code is validated against ISO 3166-1 alpha-2 and stored uppercased.
\NewDocumentCommand{\addaffiliation}{m O{} m m}{%
  \uppercase{\def\ccr@tmpcode{#4}}%
  \@ifundefined{ccr@iso@\ccr@tmpcode}{%
    \ClassError{ccr}{%
      Unknown ISO 3166-1 alpha-2 country code '#4' in affiliation '#1'}%
      {Use a 2-letter ISO 3166-1 alpha-2 code, e.g. NL, US, DE, GB.}%
  }{}%
  \edef\ccr@tmpdept{\detokenize{#2}}%
  \ifx\ccr@tmpdept\@empty\else
    \expandafter\gdef\csname ccr@aff@dept@\detokenize{#1}\endcsname{#2}%
  \fi
  \expandafter\gdef\csname ccr@aff@org@\detokenize{#1}\endcsname{#3}%
  \expandafter\xdef\csname ccr@aff@country@\detokenize{#1}\endcsname{\ccr@tmpcode}%
  \listadd\ccr@affillabels{#1}%
}


%%%%%%%%%%%%%% Title page %%%%%%%%%%%%%%%%%%%%%
\RequirePackage{calc}
\RequirePackage{hyphenat}

% XeTeX lacks microtype font expansion, so enable \sloppy globally to
% prevent overfull lines.  For pdfTeX, expansion=true in microtype
% handles this, so we leave the default (\fussy) in place.
\ifxetex
  \AtBeginDocument{\sloppy}
\fi

\renewcommand{\maketitle}{%
\noindent{\fontsize{14}{13.5}\fontseries{b}\selectfont\raggedright\nohyphens{\@title}}
\vspace{.5in}

\if@review
\else
  % If a Quarto partial has pre-built the author block (e.g. older
  % extensions defining \ccr@authorblock), use it directly.
  % Otherwise pick the new label-based path or the legacy dedup path.
  \@ifundefined{ccr@authorblock}{%
    \if@ccr@newauthors
      %%%%%%%%%%% New label-based rendering %%%%%%%%%%%
      % Pass 1: assign letters to labels in order of first reference, and
      % verify each referenced label has a matching \addaffiliation.
      % We use \@for (not \forcsvlist) for the per-author label loop because
      % \@for \edef-expands its list argument, so each iteration variable
      % holds the actual label characters rather than a macro reference.
      \newcounter{uniqaffil}%
      \renewcommand*{\theuniqaffil}{\alph{uniqaffil}}%
      \@tempcnta=\z@
      \loop\ifnum\@tempcnta<\value{ccr@nauthors}\relax
        \advance\@tempcnta\@ne
        \edef\ccr@curlabels{\csname ccr@authorlabels@\the\@tempcnta\endcsname}%
        \@for\ccr@one:=\ccr@curlabels\do{%
          \edef\ccr@onekey{\detokenize\expandafter{\ccr@one}}%
          \@ifundefined{ccr@affil@\ccr@onekey}{%
            \@ifundefined{ccr@aff@org@\ccr@onekey}{%
              \ClassError{ccr}{%
                Affiliation label '\ccr@onekey' was used by
                \string\addauthor\space but not declared with
                \string\addaffiliation}%
                {Add: \string\addaffiliation{\ccr@onekey}[Department]{University}{XX}}%
            }{}%
            \stepcounter{uniqaffil}%
            \expandafter\xdef\csname ccr@affil@\ccr@onekey\endcsname{\theuniqaffil}%
            \expandafter\xdef\csname ccr@affillabel@\theuniqaffil\endcsname{\ccr@onekey}%
          }{}%
        }%
      \repeat
      \edef\ccr@totalaffils{\number\value{uniqaffil}}%
      % Warn about declared-but-unreferenced affiliations.
      % \forlistloop pre-expands its list argument, so this works directly.
      \def\ccr@checkunused##1{%
        \edef\ccr@unusedkey{\detokenize{##1}}%
        \@ifundefined{ccr@affil@\ccr@unusedkey}{%
          \ClassWarning{ccr}{%
            Affiliation '##1' is declared but not referenced by any author}%
        }{}%
      }%
      \forlistloop{\ccr@checkunused}{\ccr@affillabels}%
      %
      % Pass 2: print authors, each with their (possibly multi-letter) superscript
      \noindent
      \def\@authsep{}%
      \@tempcnta=\z@
      \loop\ifnum\@tempcnta<\value{ccr@nauthors}\relax
        \advance\@tempcnta\@ne
        \@authsep
        \csname ccr@authorname@\the\@tempcnta\endcsname
        \edef\ccr@curlabels{\csname ccr@authorlabels@\the\@tempcnta\endcsname}%
        \textsuperscript{\textit{%
          \def\ccr@labsep{}%
          \@for\ccr@one:=\ccr@curlabels\do{%
            \ccr@labsep
            \edef\ccr@onekey{\detokenize\expandafter{\ccr@one}}%
            \csname ccr@affil@\ccr@onekey\endcsname
            \def\ccr@labsep{,}%
          }%
        }}%
        \def\@authsep{, }%
      \repeat
      \par\vspace{0.5em}
      %
      % Pass 3: print each unique affiliation once.
      % (parskip is zeroed locally so Pandoc-injected parskip from Quarto
      % renders doesn't spread the affiliation lines apart)
      {\small\itshape\parskip=0pt\relax
      \newcounter{affilprint}%
      \renewcommand*{\theaffilprint}{\alph{affilprint}}%
      \@whilenum\value{affilprint}<\ccr@totalaffils\do{%
        \stepcounter{affilprint}%
        \edef\ccr@thislab{\csname ccr@affillabel@\theaffilprint\endcsname}%
        \settowidth{\@tempdima}{\textsuperscript{\theaffilprint}\,}%
        \noindent\hangindent=\@tempdima\hangafter=1
        \textsuperscript{\theaffilprint}\,%
        \@ifundefined{ccr@aff@dept@\ccr@thislab}{}{%
          \csname ccr@aff@dept@\ccr@thislab\endcsname, %
        }%
        \csname ccr@aff@org@\ccr@thislab\endcsname, %
        \csname ccr@aff@country@\ccr@thislab\endcsname
        \par
      }}%
    \else
      %%%%%%%%%%% Legacy dedup rendering (\authorsnames / \authorsaffiliations) %%%%%%%%%%%
      % Step 1: Scan affiliations, assign a unique letter to each distinct one.
      % Affiliation superscripts use alphabetic markers (a, b, c, ...) so they
      % don't collide visually with numeric footnote marks.
      \newcounter{uniqaffil}%
      \renewcommand*{\theuniqaffil}{\alph{uniqaffil}}%
      \renewcommand*{\do}[1]{%
        \@ifundefined{ccr@affil@\detokenize{##1}}{%
          \stepcounter{uniqaffil}%
          \expandafter\xdef\csname ccr@affil@\detokenize{##1}\endcsname{\theuniqaffil}%
          \expandafter\gdef\csname ccr@affiltext@\theuniqaffil\endcsname{##1}%
        }{}%
      }%
      \dolistloop{\listaffiliations}%
      \edef\ccr@totalaffils{\number\value{uniqaffil}}%
      %
      % Step 2: Print authors with looked-up superscript letters (italicised
      % inline so they read as affiliation markers rather than stray letters)
      \noindent
      \def\@authsep{}%
      \renewcommand*{\dotwo}[2]{%
        \@authsep##1\textsuperscript{\textit{\csname ccr@affil@\detokenize{##2}\endcsname}}%
        \def\@authsep{, }%
      }%
      \looptwo\listauthors\listaffiliations
      \par\vspace{0.5em}
      %
      % Step 3: Print each unique affiliation once
      {\small\itshape\parskip=0pt\relax
      \newcounter{affilprint}%
      \renewcommand*{\theaffilprint}{\alph{affilprint}}%
      \@whilenum\value{affilprint}<\ccr@totalaffils\do{%
        \stepcounter{affilprint}%
        \settowidth{\@tempdima}{\textsuperscript{\theaffilprint}\,}%
        \noindent\hangindent=\@tempdima\hangafter=1
        \textsuperscript{\theaffilprint}\,\csname ccr@affiltext@\theaffilprint\endcsname\par
      }}%
    \fi
  }{%
    \ccr@authorblock
  }%
\fi

\vspace{1em}
\begin{quote}\small
\textbf{Abstract}\\\show@abstract
\\\\
\textbf{Keywords:} \show@keywords
\end{quote}

\if@review
\linenumbers
\fi
}

%%%%%%%%%%%%%% Sections %%%%%%%%%%%%%%%%%%%%%
\renewcommand{\section}{%
\@startsection{section}{1}{0pt}%
{-1.5ex plus -1ex minus -.2ex}{2ex}%
{\fontsize{14}{13.5}\fontseries{b}\selectfont}%
}
\setcounter{secnumdepth}{0}

\renewcommand{\appendixname}{Appendix}

% From: https://tex.stackexchange.com/a/160850
\def\@seccntformat#1{\@ifundefined{#1@cntformat}%
   {\csname the#1\endcsname\quad}  % default
   {\csname #1@cntformat\endcsname}% enable individual control
}
\let\oldappendix\appendix %% save current definition of \appendix
\renewcommand\appendix{%
    \oldappendix    
    % Force sections to start on new page
    \let\oldsection\section
    \renewcommand{\section}{\clearpage\oldsection}
    % Renew sections to 'Appendix A <title>'
    \setcounter{secnumdepth}{1} % start numbering sections again
    \newcommand{\section@cntformat}{\appendixname~\thesection\quad}
    % Count figures/tables from A1
    \setcounter{table}{0}
    \renewcommand{\thetable}{A\arabic{table}}
    \setcounter{figure}{0}
    \renewcommand{\thetable}{A\arabic{table}}
}

%%%%%%%%%%%%%% Reference handling %%%%%%%%%%%%%%%%%%%%%
% When used via Quarto (which handles citations with citeproc), pass the
% 'nobib' class option to skip biblatex entirely.
\if@loadbiblatex
  \RequirePackage{csquotes}
  \RequirePackage[style=apa,sortcites=true,sorting=nyt,backend=biber]{biblatex}

  \DeclareLanguageMapping{american}{american-apa}

  \renewcommand{\bibfont}{\small}
  \setlength{\bibhang}{\parindent}
\fi
