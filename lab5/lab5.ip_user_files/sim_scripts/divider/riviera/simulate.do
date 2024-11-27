transcript off
onbreak {quit -force}
onerror {quit -force}
transcript on

asim +access +r +m+divider  -L xbip_utils_v3_0_11 -L axi_utils_v2_0_7 -L xbip_pipe_v3_0_7 -L xbip_dsp48_wrapper_v3_0_5 -L xbip_dsp48_addsub_v3_0_7 -L xbip_bram18k_v3_0_7 -L mult_gen_v12_0_19 -L floating_point_v7_0_21 -L xbip_dsp48_mult_v3_0_7 -L xbip_dsp48_multadd_v3_0_7 -L div_gen_v5_1_20 -L xil_defaultlib -L secureip -O5 xil_defaultlib.divider

do {divider.udo}

run 1000ns

endsim

quit -force
