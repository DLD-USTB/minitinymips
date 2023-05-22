##################################################################
# CHECK VIVADO VERSION
##################################################################

set scripts_vivado_version 2018.3
set current_vivado_version [version -short]

if { [string first $scripts_vivado_version $current_vivado_version] == -1 } {
  catch {common::send_msg_id "IPS_TCL-100" "ERROR" "This script was generated using Vivado <$scripts_vivado_version> and is being run in <$current_vivado_version> of Vivado. Please run the script in Vivado <$scripts_vivado_version> then open the design in Vivado <$current_vivado_version>. Upgrade the design by running \"Tools => Report => Report IP Status...\", then run write_ip_tcl to create an updated script."}
  return 1
}

##################################################################
# START
##################################################################

# To test this script, run the following commands from Vivado Tcl console:
# source clk_wiz.tcl
# If there is no project opened, this script will create a
# project, but make sure you do not have an existing project
# <./project-test/minitinyMIPS.xpr> in the current working folder.

set list_projs [get_projects -quiet]
if { $list_projs eq "" } {
  create_project minitinyMIPS project-test -part xc7a35tcsg324-1
  set_property target_language Verilog [current_project]
  set_property simulator_language Mixed [current_project]
}

##################################################################
# CHECK IPs
##################################################################

set bCheckIPs 1
set bCheckIPsPassed 1
if { $bCheckIPs == 1 } {
  set list_check_ips { xilinx.com:ip:clk_wiz:6.0 }
  set list_ips_missing ""
  common::send_msg_id "IPS_TCL-1001" "INFO" "Checking if the following IPs exist in the project's IP catalog: $list_check_ips ."

  foreach ip_vlnv $list_check_ips {
  set ip_obj [get_ipdefs -all $ip_vlnv]
  if { $ip_obj eq "" } {
    lappend list_ips_missing $ip_vlnv
    }
  }

  if { $list_ips_missing ne "" } {
    catch {common::send_msg_id "IPS_TCL-105" "ERROR" "The following IPs are not found in the IP Catalog:\n  $list_ips_missing\n\nResolution: Please add the repository containing the IP(s) to the project." }
    set bCheckIPsPassed 0
  }
}

if { $bCheckIPsPassed != 1 } {
  common::send_msg_id "IPS_TCL-102" "WARNING" "Will not continue with creation of design due to the error(s) above."
  return 1
}

##################################################################
# CREATE IP clk_wiz_0
##################################################################

set clk_wiz clk_wiz_0
create_ip -name clk_wiz -vendor xilinx.com -library ip -version 6.0 -module_name $clk_wiz

set_property -dict { 
  CONFIG.PRIMITIVE {PLL}
  CONFIG.USE_FREQ_SYNTH {true}
  CONFIG.USE_PHASE_ALIGNMENT {true}
  CONFIG.SECONDARY_SOURCE {Single_ended_clock_capable_pin}
  CONFIG.CLKOUT1_REQUESTED_OUT_FREQ {10}
  CONFIG.PRIM_SOURCE {Single_ended_clock_capable_pin}
  CONFIG.CLKOUT1_DRIVES {BUFG}
  CONFIG.CLKOUT2_DRIVES {BUFG}
  CONFIG.CLKOUT3_DRIVES {BUFG}
  CONFIG.CLKOUT4_DRIVES {BUFG}
  CONFIG.CLKOUT5_DRIVES {BUFG}
  CONFIG.CLKOUT6_DRIVES {BUFG}
  CONFIG.CLKOUT7_DRIVES {BUFG}
  CONFIG.USE_LOCKED {false}
  CONFIG.USE_RESET {false}
  CONFIG.MMCM_DIVCLK_DIVIDE {5}
  CONFIG.MMCM_CLKFBOUT_MULT_F {41}
  CONFIG.MMCM_COMPENSATION {ZHOLD}
  CONFIG.MMCM_CLKOUT0_DIVIDE_F {82}
  CONFIG.CLKOUT1_JITTER {446.763}
  CONFIG.CLKOUT1_PHASE_ERROR {313.282}
} [get_ips $clk_wiz]

##################################################################

