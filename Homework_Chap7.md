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
  </tbody>
</table>

- **bne**:
- **sra**:


