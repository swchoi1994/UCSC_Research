How to generate traces
----------------------

1. Download pin-2.14 and copy TraceGen folder to <pin-2.14>/source/tools/TraceGen

http://software.intel.com/sites/landingpage/pintool/downloads/pin-2.14-71313-gcc.4.4.7-linux.tar.gz

Manual: https://software.intel.com/sites/landingpage/pintool/docs/71313/Pin/html/

2. Install snappy (a compression/decompression library)

   * Download: http://google.github.io/snappy/                           
   * Install: if not root user, install with ./configure --prefix=/gpfs/home/juz138/work/benchmark/snappy/ 

3. Compile TranceGen

	cd <pin-2.11>/source/tools/TraceGen
	make TOOLS_DIR=<pin-2.14>/source/tools -j 8

If you have any compiling issues:
* Check paths and options in Makefile and tracegen.mk
* Check paths and options in <pin-2.14>source/tools/makefile.gnu.config

4. Run TraceGen

	<pin-2.14>/intel64/bin/pinbin -t <pin-2.14>/source/tools/TraceGen/obj-intel64/tracegen -prefix prefix_name -slice_size size point1 point2 ... -- <command to run the workload to be traced>

-h:		print out usage information
-prefix:	set the file name of your trace
-slice_size:	number of instructions in each sample
point1, point2, …	


e.g., You can test TraceGen by catching a trace when you execute “ls”:

<pin-2.14>/intel64/bin/pinbin -t <pin-2.14>/source/tools/TraceGen/obj-intel64/tracegen -prefix LS -slice_size 10 1 2 3 4 5 -- ls