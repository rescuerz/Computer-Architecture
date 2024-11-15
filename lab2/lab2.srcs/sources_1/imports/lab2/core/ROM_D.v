`timescale 1ns / 1ps

module ROM_D(
    input[6:0] a,
    output[31:0] spo
);

    (* ram_style = "block" *) reg[31:0] inst_data[0:127];

    initial	begin
        $readmemh("D:/ViVado/CA_Lab/lab2/lab2.srcs/sources_1/imports/lab2/core/rom.mem", inst_data);
    end

    assign spo = inst_data[a];

endmodule