# 
# Synthesis run script generated by Vivado
# 

set TIME_start [clock seconds] 
namespace eval ::optrace {
  variable script "D:/ViVado/CA_Lab/lab4/lab4.runs/synth_1/top.tcl"
  variable category "vivado_synth"
}

# Try to connect to running dispatch if we haven't done so already.
# This code assumes that the Tcl interpreter is not using threads,
# since the ::dispatch::connected variable isn't mutex protected.
if {![info exists ::dispatch::connected]} {
  namespace eval ::dispatch {
    variable connected false
    if {[llength [array get env XILINX_CD_CONNECT_ID]] > 0} {
      set result "true"
      if {[catch {
        if {[lsearch -exact [package names] DispatchTcl] < 0} {
          set result [load librdi_cd_clienttcl[info sharedlibextension]] 
        }
        if {$result eq "false"} {
          puts "WARNING: Could not load dispatch client library"
        }
        set connect_id [ ::dispatch::init_client -mode EXISTING_SERVER ]
        if { $connect_id eq "" } {
          puts "WARNING: Could not initialize dispatch client"
        } else {
          puts "INFO: Dispatch client connection id - $connect_id"
          set connected true
        }
      } catch_res]} {
        puts "WARNING: failed to connect to dispatch server - $catch_res"
      }
    }
  }
}
if {$::dispatch::connected} {
  # Remove the dummy proc if it exists.
  if { [expr {[llength [info procs ::OPTRACE]] > 0}] } {
    rename ::OPTRACE ""
  }
  proc ::OPTRACE { task action {tags {} } } {
    ::vitis_log::op_trace "$task" $action -tags $tags -script $::optrace::script -category $::optrace::category
  }
  # dispatch is generic. We specifically want to attach logging.
  ::vitis_log::connect_client
} else {
  # Add dummy proc if it doesn't exist.
  if { [expr {[llength [info procs ::OPTRACE]] == 0}] } {
    proc ::OPTRACE {{arg1 \"\" } {arg2 \"\"} {arg3 \"\" } {arg4 \"\"} {arg5 \"\" } {arg6 \"\"}} {
        # Do nothing
    }
  }
}

proc create_report { reportName command } {
  set status "."
  append status $reportName ".fail"
  if { [file exists $status] } {
    eval file delete [glob $status]
  }
  send_msg_id runtcl-4 info "Executing : $command"
  set retval [eval catch { $command } msg]
  if { $retval != 0 } {
    set fp [open $status w]
    close $fp
    send_msg_id runtcl-5 warning "$msg"
  }
}
OPTRACE "synth_1" START { ROLLUP_AUTO }
OPTRACE "Creating in-memory project" START { }
create_project -in_memory -part xc7a100tcsg324-1

set_param project.singleFileAddWarning.threshold 0
set_param project.compositeFile.enableAutoGeneration 0
set_param synth.vivado.isSynthRun true
set_property webtalk.parent_dir D:/ViVado/CA_Lab/lab4/lab4.cache/wt [current_project]
set_property parent.project_path D:/ViVado/CA_Lab/lab4/lab4.xpr [current_project]
set_property default_lib xil_defaultlib [current_project]
set_property target_language Verilog [current_project]
set_property board_part digilentinc.com:nexys-a7-100t:part0:1.3 [current_project]
set_property ip_output_repo d:/ViVado/CA_Lab/lab4/lab4.cache/ip [current_project]
set_property ip_cache_permissions {read write} [current_project]
OPTRACE "Creating in-memory project" END { }
OPTRACE "Adding files" START { }
read_verilog {
  D:/ViVado/CA_Lab/lab4/lab4.srcs/sources_1/imports/lab4/auxillary/function.vh
  D:/ViVado/CA_Lab/lab4/lab4.srcs/sources_1/imports/lab4/cache/addr_define.vh
}
read_mem {
  D:/ViVado/CA_Lab/lab4/lab4.srcs/sources_1/imports/lab4/cache/ram.mem
  D:/ViVado/CA_Lab/lab4/lab4.srcs/sources_1/imports/lab4/core/rom.mem
}
read_verilog -library xil_defaultlib {
  D:/ViVado/CA_Lab/lab4/lab4.srcs/sources_1/imports/lab4/core/ALU.v
  D:/ViVado/CA_Lab/lab4/lab4.srcs/sources_1/imports/lab4/auxillary/CPUTEST.v
  D:/ViVado/CA_Lab/lab4/lab4.srcs/sources_1/imports/lab4/core/CtrlUnit.v
  D:/ViVado/CA_Lab/lab4/lab4.srcs/sources_1/imports/lab4/core/HazardDetectionUnit.v
  D:/ViVado/CA_Lab/lab4/lab4.srcs/sources_1/imports/lab4/core/ImmGen.v
  D:/ViVado/CA_Lab/lab4/lab4.srcs/sources_1/imports/lab4/common/MUX2T1_32.v
  D:/ViVado/CA_Lab/lab4/lab4.srcs/sources_1/imports/lab4/common/MUX4T1_32.v
  D:/ViVado/CA_Lab/lab4/lab4.srcs/sources_1/imports/lab4/common/REG32.v
  D:/ViVado/CA_Lab/lab4/lab4.srcs/sources_1/imports/lab4/core/REG_EX_MEM.v
  D:/ViVado/CA_Lab/lab4/lab4.srcs/sources_1/imports/lab4/core/REG_ID_EX.v
  D:/ViVado/CA_Lab/lab4/lab4.srcs/sources_1/imports/lab4/core/REG_IF_ID.v
  D:/ViVado/CA_Lab/lab4/lab4.srcs/sources_1/imports/lab4/core/REG_MEM_WB.v
  D:/ViVado/CA_Lab/lab4/lab4.srcs/sources_1/imports/lab4/core/ROM_D.v
  D:/ViVado/CA_Lab/lab4/lab4.srcs/sources_1/imports/lab4/core/RV32core.v
  D:/ViVado/CA_Lab/lab4/lab4.srcs/sources_1/imports/lab4/core/Regs.v
  D:/ViVado/CA_Lab/lab4/lab4.srcs/sources_1/imports/lab4/common/add_32.v
  D:/ViVado/CA_Lab/lab4/lab4.srcs/sources_1/imports/lab4/auxillary/btn_scan.v
  D:/ViVado/CA_Lab/lab4/lab4.srcs/sources_1/imports/lab4/cache/cache.v
  D:/ViVado/CA_Lab/lab4/lab4.srcs/sources_1/imports/lab4/common/cmp_32.v
  D:/ViVado/CA_Lab/lab4/lab4.srcs/sources_1/imports/lab4/cache/cmu.v
  D:/ViVado/CA_Lab/lab4/lab4.srcs/sources_1/imports/lab4/cache/data_ram.v
  D:/ViVado/CA_Lab/lab4/lab4.srcs/sources_1/imports/lab4/auxillary/debug_clk.v
  D:/ViVado/CA_Lab/lab4/lab4.srcs/sources_1/imports/lab4/auxillary/debug_ctrl.v
  D:/ViVado/CA_Lab/lab4/lab4.srcs/sources_1/imports/lab4/auxillary/display.v
  D:/ViVado/CA_Lab/lab4/lab4.srcs/sources_1/imports/lab4/auxillary/my_clk_gen.v
  D:/ViVado/CA_Lab/lab4/lab4.srcs/sources_1/imports/lab4/auxillary/parallel2serial.v
  D:/ViVado/CA_Lab/lab4/lab4.srcs/sources_1/imports/lab4/auxillary/uart_buffer.v
  D:/ViVado/CA_Lab/lab4/lab4.srcs/sources_1/imports/lab4/auxillary/top.v
}
read_vhdl -library xil_defaultlib D:/ViVado/CA_Lab/lab4/lab4.srcs/sources_1/imports/lab4/auxillary/UART_TX_CTRL.vhd
OPTRACE "Adding files" END { }
# Mark all dcp files as not used in implementation to prevent them from being
# stitched into the results of this synthesis run. Any black boxes in the
# design are intentionally left as such for best results. Dcp files will be
# stitched into the design at a later time, either when this synthesis run is
# opened, or when it is stitched into a dependent implementation run.
foreach dcp [get_files -quiet -all -filter file_type=="Design\ Checkpoint"] {
  set_property used_in_implementation false $dcp
}
read_xdc D:/ViVado/CA_Lab/lab4/lab4.srcs/constrs_1/imports/lab4/constraint.xdc
set_property used_in_implementation false [get_files D:/ViVado/CA_Lab/lab4/lab4.srcs/constrs_1/imports/lab4/constraint.xdc]

set_param ips.enableIPCacheLiteLoad 1
close [open __synthesis_is_running__ w]

OPTRACE "synth_design" START { }
synth_design -top top -part xc7a100tcsg324-1
OPTRACE "synth_design" END { }
if { [get_msg_config -count -severity {CRITICAL WARNING}] > 0 } {
 send_msg_id runtcl-6 info "Synthesis results are not added to the cache due to CRITICAL_WARNING"
}


OPTRACE "write_checkpoint" START { CHECKPOINT }
# disable binary constraint mode for synth run checkpoints
set_param constraints.enableBinaryConstraints false
write_checkpoint -force -noxdef top.dcp
OPTRACE "write_checkpoint" END { }
OPTRACE "synth reports" START { REPORT }
create_report "synth_1_synth_report_utilization_0" "report_utilization -file top_utilization_synth.rpt -pb top_utilization_synth.pb"
OPTRACE "synth reports" END { }
file delete __synthesis_is_running__
close [open __synthesis_is_complete__ w]
OPTRACE "synth_1" END { }
