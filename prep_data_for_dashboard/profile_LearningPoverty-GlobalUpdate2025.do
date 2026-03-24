*==============================================================================*
*! LEARNING POVERTY (LP) - Global Update 2025
*! Project information at: https://github.com/fapn91/LearningPoverty-GlobalUpdate2025
*! EduAnalytics Team, World Bank Group [eduanalytics@worldbank.org]

*! PROFILE: Required step before running any do-files in this project
*==============================================================================*

quietly {

	/*
	Steps in this do-file:
	1) General program setup
	2) Define user-dependant path for local clone repo
	3) Download and install required user written ado's
	4) Flag that profile was successfully loaded						*/

	*--------------------------------------------------------------------------
	**# 1) General program setup
	*--------------------------------------------------------------------------
	clear               all
	capture log         close _all
	set more            off
	set varabbrev       off, permanently
	set emptycells      drop
	set maxvar          120000
	set scrollbufsize 	2048000
	set linesize        135
	set reshape_favor 	speed
	set doeditbackup 	off
	set graphics 		on
	cap version         19
	if _rc != 0	version 18
	*--------------------------------------------------------------------------

	*--------------------------------------------------------------------------
	**# 2) Define user-dependant path for local clone repo
	*--------------------------------------------------------------------------
	* Change here only if this repo is renamed
	local this_repo     "LearningPoverty-GlobalUpdate2025"

	* The remaining of this section is standard in EduAnalytics repos

	* One of two options can be used to "know" the clone path for a given user
	* A. the user had previously saved their GitHub location with -whereis-,
	*    so the clone is a subfolder with this Project Name in that location
	* B. through a window dialog box where the user manually selects a file

	* Method A - Github location stored in -whereis-
	*---------------------------------------------
	capture whereis github
	if _rc == 0 global clone "`r(github)'/`this_repo'"

	* Method B - clone selected manually
	*---------------------------------------------
	else {
		* Display an explanation plus warning to force the user to look at the dialog box
		noi disp as txt `"{phang}Your GitHub clone local could not be automatically identified by the command {it: whereis}, so you will be prompted to do it manually. To save time, you could install -whereis- with {it: ssc install whereis}, then store your GitHub location, for example {it: whereis github "C:/Users/AdaLovelace/GitHub"}.{p_end}"'
		noi disp as error _n `"{phang}Please use the dialog box to manually select the file `this_run_do' in your machine.{p_end}"'

		* Dialog box to select file manually
		capture window fopen path_and_run_do "Select the master do-file for this project (`this_run_do'), expected to be inside any path/`this_repo'/" "Do Files (*.do)|*.do|All Files (*.*)|*.*" do

		* If user clicked cancel without selecting a file or chose a file that is not a do, will run into error later
		if _rc == 0 {

			* Pretend user chose what was expected in terms of string lenght to parse
			local user_chosen_do   = substr("$path_and_run_do",   - strlen("`this_run_do'"),     strlen("`this_run_do'") )
			local user_chosen_path = substr("$path_and_run_do", 1 , strlen("$path_and_run_do") - strlen("`this_run_do'") - 1 )

			* Replace backward slash with forward slash to avoid possible troubles
			local user_chosen_path = subinstr("`user_chosen_path'", "\", "/", .)

			* Check if master do-file chosen by the user is master_run_do as expected
			* If yes, attributes the path chosen by user to the clone, if not, exit
			if "`user_chosen_do'" == "`this_run_do'"  global clone "`user_chosen_path'"
		}
		
		else {
			noi disp as error _newline "{phang}You selected $path_and_run_do as the master do file. This does not match what was expected (any path/`this_repo'/`this_run_do'). Code aborted.{p_end}"
			error 2222
		}
	}
	*--------------------------------------------------------------------------

	*--------------------------------------------------------------------------
	**# 3) Download and install required user written ado's
	*--------------------------------------------------------------------------
	* Fill this list will all user-written commands this project requires
	* that can be installed automatically from ssc
	local user_commands wbopendata mdesc fre keeporder unique moreobs extremes ereplace geoplot colorpalette 

	* Loop over all the commands to test if they are already installed, if not, then install
	foreach command of local user_commands {
		cap which `command'
		if _rc == 111 ssc install `command'
	}

	* Load other auxiliary programs, that are found in this Repo

	* Preferred list selects 1 observation per country from rawfull (unique 
	* proficiency) and trims the dataset on the wide sense (keep 1 enrollment, 
	* 1 population only)
	//do "${clone}/01_data/012_programs/01261_preferred_list.do"
	*--------------------------------------------------------------------------
	
	*--------------------------------------------------------------------------
	**# 4) Set subfolders as globals
	*--------------------------------------------------------------------------
	
	* We will use the data hosted in the Network 
	global network 	"//wbgfscifs01/GEDEDU/"
	cap cd "${network}"
	if _rc == 0 {
		noi display as result _n "You have access to the network"
		global network_is_available 1
		global input_from_network "${network}/GDB/Projects/WLD_2025_FGT-CLO/github_outputs/LPV"
	}
	else {
		noi display as error _n "You don't have access to the network. Contact the EduAnalytics Team to request access to the data."
		global network_is_available 0
		* Include the path of your local machine where you will host the data 
		// global input_from_network ""
	}
	
	* Change directory
	cd "${clone}"

	* Sub-folders     
	global input 	"${clone}/01_inputs"
	global code 	"${clone}/02_programs"
	global output	"${clone}/03_outputs"
	*--------------------------------------------------------------------------

	*--------------------------------------------------------------------------
	**# 5) Flag that profile was successfully loaded
	*--------------------------------------------------------------------------
	noi disp as result _n `"{phang}`this_repo' clone sucessfully set up (${clone}).{p_end}"'
	*-----------------------------------------------------------------------------

}
