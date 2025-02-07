`timescale 1ns / 1ps

module ROM_D(
    input[6:0] a,
    output[31:0] spo
);

    reg[31:0] inst_data[0:127];

    initial	begin
        // D:\ViVado\CA_Lab\lab5\lab5.srcs\sources_1\imports\lab5\core\rom.mem
        $readmemh("D:/ViVado/CA_Lab/lab5/lab5.srcs/sources_1/imports/lab5/core/rom.mem", inst_data);
    end

    assign spo = inst_data[a];

endmodule