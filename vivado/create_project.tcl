create_project minitinyMIPS ./project -part xc7a35tcsg324-1
add_files -fileset sources_1 ../vsrc/Core/ALUct.v ../vsrc/Core/ALU.v ../vsrc/Core/Control.v ../vsrc/Core/Core.v ../vsrc/Core/IFU.v ../vsrc/Core/RegFile.v ../vsrc/Memory/Memory.v ../vsrc/Memory/Router.v ../vsrc/Memory/Device.v ../vsrc/Top.v
add_files -fileset sim_1 ../vsrc/Simulation/SimDevice.v ../vsrc/Simulation/SimTop.v ../vsrc/Simulation/SimEnv.v
source ./ip/clk_wiz.tcl
set_property top SimEnv [get_filesets sim_1]
set_property top Top [get_filesets sources_1]

