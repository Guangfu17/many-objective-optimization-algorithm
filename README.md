# many-objective-optimization-algorithm
A Decomposition-Based Evolutionary Algorithm with Adaptive Weight  
Vectors for Multi- and Many-objective Optimization, Evostar 2020.

DBEAAWV.m is the algorithm. DTLZ2 is an example of problem.  
Run the algorithm:     
main('-algorithm',Value,'-problem',Value,...) runs one algorithm on a problem with acceptable parameters.  
For example: main('-algorithm',@DBEAAWV,'-problem',DTLZ2,'-N',200,'-M',3)  

All the acceptable parameters:  
%   '-N'            <positive integer>  population size  
%   '-M'            <positive integer>  number of objectives  
%   '-D'            <positive integer>  number of variables  
%	  '-algorithm'    <function handle>   algorithm function  
%	  '-problem'      <function handle>   problem function  
%	  '-evaluation'   <positive integer>  maximum number of evaluations  
%   '-run'          <positive integer>  run number  
%   '-save'         <integer>           number of saved populations  
%   '-outputFcn'	  <function handle>   function invoked after each generation  
