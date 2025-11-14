# Homework_Chap7

在开始本次作业前，为便于描述，附两张图于此。

![](/home/zrheng/.config/marktext/images/2025-11-09-14-23-16-image.png)

![](/home/zrheng/.config/marktext/images/2025-11-09-14-23-52-image.png)

## T7.1&7.2

(a)$RegWrite$恒为1->寄存器堆写使能保持打开，会将$Instr$的7-11为以寄存器的形式译码并将$Result$的结果写入其中。会使S类型和B类型的指令出错，因其无需写寄存器，$Instr$的7-11位参与组成立即数。若$RegWrite$为1,其将错误的写若干寄存器。

(b)$ALUOp_1$恒为1->ALU的行为将由$Instr$的$funct3$字段和$funct7$字段决定。对于R类型和I-type ALU指令来说完全不受影响。对于B类型，讨论：首先beq指令肯定会被影响。正常情况下，ALU应当做减法操作；但根据$funct3$（000）解析出的ALU将会执行加法操作。换句话说，ALU将会以R类型指令的$funct3$和$funct7$决定所执行的运算。那么由于B类型的指令$funct7$字段用来组成立即数，所以除非beq指令为0100000xxxxxxxxxx000xxxxx1100011时恰好ALU做减法，其余均会出错。对于除I-type ALU之外的I类型指令和S类型指令同B类型指令。

(c)$ALUOp_0$恒为1->ALU将忠实的执行减法运算（只有B类型指令是进行两个寄存器相减）。B类型指令将不受影响。其余指令全错。

(d)$MemWrite$恒为1->数据内存写使能保持打开，会将RD2的值忠实的写入$ALUResult$的地址。除了S类型外的其余指令均会意外的写入内存。似乎程序不会崩溃，除非写入的地址为只读字段等非法写入。但是数据内存将被意料之外的修改，可能导致后续访存指令读取错误数值。

(e)$ImmSrc_1$恒为1->立即数均以B类型指令方式译码。除B类型指令和R类型指令（不涉及立即数）外，其余指令全错（立即数无法正确译码）。

(f)$ImmSrc_0$恒为1->立即数均以S类型指令方式译码。除S类型指令和R类型指令外，其余指令全错。

(g)$ResultSrc_1$恒为1->$Result$均J类型指令的形式得到。除J类型指令外和B类型指令外，其余指令全错。B类型指令关注的点在$PCNext$的值，$Result$是多少不是很重要。

(h)$ResultSrc_0$恒为1->$Result$均以访存的形式得到。R类型和I-type ALU类型的指令会出错，因为他们的$Result$是ALU运算的结果。

(i)$PCSrc$恒为1->$PCNext$的值均由$PCTarget$得到。除了J类型指令和B类型指令外全错。其余指令的$PCNext$是正常的$PC+4$得到。

(j)$ALUSrc$恒为1->ALU的第二个操作数从$Extend$模块中来。所有R类型指令和B类型全错，因其ALU的两个操作数均来源于寄存器。

## T7.3&7.4

先给出扩展后的指令真值表和数据通路。再针对不同指令进行解释。

<table>
  <thead>
    <tr>
      <th>指令</th>
      <th>Op</th>
      <th>RegWrite</th>
      <th>ImmSrc</th>
      <th>ALUSrc</th>
      <th>MemWrite</th>
      <th>ResultSrc</th>
      <th>Branch</th>
      <th>ALUOp</th>
      <th>Jump</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <td>sw</td>
      <td>0100011</td>
      <td>0</td>
      <td>01</td>
      <td>1</td>
      <td>1</td>
      <td>xx</td>
      <td>0</td>
      <td>00</td>
      <td>0</td>
    </tr>
    <tr>
      <td>R-type</td>
      <td>0110011</td>
      <td>1</td>
      <td>xx</td>
      <td>0</td>
      <td>0</td>
      <td>00</td>
      <td>0</td>
      <td>10</td>
      <td>0</td>
    </tr>
    <tr>
      <td>beq</td>
      <td>1100011</td>
      <td>0</td>
      <td>10</td>
      <td>0</td>
      <td>0</td>
      <td>xx</td>
      <td>1</td>
      <td>01</td>
      <td>0</td>
    </tr>
    <tr>
      <td>I-type ALU</td>
      <td>0010011</td>
      <td>1</td>
      <td>00</td>
      <td>1</td>
      <td>0</td>
      <td>00</td>
      <td>0</td>
      <td>10</td>
      <td>0</td>
    </tr>
    <tr>
      <td>jal</td>
      <td>1101111</td>
      <td>1</td>
      <td>11</td>
      <td>x</td>
      <td>0</td>
      <td>10</td>
      <td>0</td>
      <td>xx</td>
      <td>1</td>
    </tr>
    <tr>
      <td> bne </td>
      <td> 1110011 </td>
      <td> 0 </td>
      <td> 10 </td>
      <td> 0 </td>
      <td> 0 </td>
      <td> x </td>
      <td> 1 </td>
      <td> 01 </td>
      <td> 0 </td>
    </tr>
    <tr>
      <td> sra </td>
      <td> 0110011 </td>
      <td> 1 </td>
      <td> xx </td>
      <td> 0 </td>
      <td> 0 </td>
      <td> 00 </td>
      <td> 0 </td>
      <td> 10 </td>
      <td> 0 </td>
    </tr>
    <tr>
      <td> lbu </td>
      <td> 0000011 </td>
      <td> 1 </td>
      <td> 00 </td>
      <td> 1 </td>
      <td> 0 </td>
      <td> 01 </td>
      <td> 0 </td>
      <td> 00 </td>
      <td> 0 </td>
    </tr>
    <tr>
      <td> jalr </td>
      <td> 1100111 </td>
      <td> 1 </td>
      <td> 11 </td>
      <td> 1 </td>
      <td> 0 </td>
      <td> 10 </td>
      <td> 0 </td>
      <td> 00 </td>
      <td> 1 </td>
    </tr>
    <tr>
      <td> auipc </td>
      <td> 0010111 </td>
      <td> 1 </td>
      <td> 100? </td>
      <td> 1 </td>
      <td> 0 </td>
      <td> 00 </td>
      <td> 0 </td>
      <td> 00 </td>
      <td> 0 </td>
    </tr>
  </tbody>
</table>

- **bne**:当两个寄存器的值不同的时候，进行跳转。跳转的地址来自于$Extend$。只需要将beq修改一下即可：检查$func3$字段与ALU给出的$Zero$信号，若前者为001且后者为0,则$PCSrc$信号为1；否则为0。

- **sra**:一条简单的R-type指令，只需要修改ALU译码器的真值表，将其扩展为4位的控制信号并新支持一下sra指令就行。下面尝试给出修改后的ALU实现。
  
  ```verilog
  // ALU：组合逻辑，根据 ALUControl 执行运算
  module ALU (
      input  logic [31:0] A,
      input  logic [31:0] B,
      input  logic [2:0]  ALUControl,
      output logic [31:0] Result,
      output logic        Zero
  );
      always_comb begin
          case (ALUControl)
              3'b000: Result = A + B;      // add
              3'b001: Result = A - B;      // sub
              3'b010: Result = A & B;      // and
              3'b011: Result = A | B;      // or
              3'b100: Result = A >>> B[4:0]; // sra (Shift Right Arithmetic)
  
              3'b101: Result = ($signed(A) < $signed(B)) ? 32'd1 : 32'd0; // slt (signed)
  
            default: Result = 32'd0;
        endcase
    end
  
    assign Zero = (Result == 32'd0);
  
  endmodule
  ```

- **lbu**:和lw类似，不过在读取内存的时候只读后8个bit。新增加一个控制信号$RDMode$：真值表如下
  
  <table>
  <th> func3 </th>
  <th> RDMode </th>
  <tr>
      <td> 000
      <td> 10
  </tr>
  <tr>
      <td> 100 
      <td> 00
  </tr>
  <tr>    
      <td> 101
      <td> 01
  </tr>    
  </table>
  
  当$RDMode$为10时，正常读word；为00时，读一个byte；为01时，读half word（2个byte）

- **jalr**:与jal指令不同之处仅在于，PC=rs1+imm。所以要修改$PCSrc$控制单元，将其扩展为2位：00表示PCPlus4，01表示PCTarget，10表示来自ALUResult。同时需要把ALUResult连线到最左侧的多路选择器。

- **auipc**:这条指令似乎要扩展$immSrc$。具体来说，U类型指令立即数生成时应当取$Instr$的12-31位，并将低12位置0。

# T7.7

应当重新设计内存读单元。因为其在关键路径中会出现两次：更改后的单周期时间为：

100+100+120+100+30=450ps。

## T7.8

ALU延迟减少20ps，整体的单周期时间也减少20ps到730ps。执行一亿条指令所需时间为$10^{11} \times 703\div 10^{12} = 73$秒

## T7.30

![](/home/zrheng/Documents/DDCA2025Fall/Homework_Chap7/T7.30.drawio.png)

第五时钟周期即为图中红色框的部分。寄存器操作有：读s2,s5；写s1

## T7.31

![](/home/zrheng/Documents/DDCA2025Fall/Homework_Chap7/T7.31.drawio.png)

同理，读寄存器s0,写寄存器s1

## T7.32

![](/home/zrheng/Documents/DDCA2025Fall/Homework_Chap7/T7.32.drawio.png)

红色方框内为Stall的部分，是由于所读寄存器的值尚未写入造成的。

## T7.33

![](/home/zrheng/Documents/DDCA2025Fall/Homework_Chap7/T7.33.drawio.png)

同上题

## T7.34

| 时钟周期           | 1   | 2   | 3   | 4   | 5         | 6         | 7   | 8   | 9   | 10  | 11  | 12  |
| -------------- | --- | --- | --- | --- | --------- | --------- | --- | --- | --- | --- | --- | --- |
| **I1: addi**   | IF  | ID  | EX  | MEM | WB        |           |     |     |     |     |     |     |
| **I2: lw s2**  |     | IF  | ID  | EX  | MEM       | WB        |     |     |     |     |     |     |
| **I3: lw s5**  |     |     | IF  | ID  | **stall** | EX        | MEM | WB  |     |     |     |     |
| **I4: add s3** |     |     |     | IF  | ID        | **stall** | EX  | MEM | WB  |     |     |     |
| **I5: or s4**  |     |     |     |     | IF        | ID        | EX  | MEM | WB  |     |     |     |
| **I6: and s2** |     |     |     |     |           | IF        | ID  | EX  | MEM | WB  |     |     |

流水线图如上表所示。共需10个时钟周期，CPI=1.667
