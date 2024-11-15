`timescale 1ns / 1ps

module ROM_D(
    input[7:0] a,
    output[31:0] spo
);

    reg[31:0] inst_data[0:255];

    initial	begin
        // D:\ViVado\CA_Lab\lab3\lab3.srcs\sources_1\imports\lab3\core\rom.mem
        $readmemh("D:/ViVado/CA_Lab/lab3/lab3.srcs/sources_1/imports/lab3/core/rom.mem", inst_data);
    end

    assign spo = inst_data[a];

endmodule