package tomorrow.ver1.arithmetic

import strage.IntegerRegister
import scala.collection.immutable.Map
import tomorrow.ver1.ThreeRegisterOperandOpcode
import cpu.instruction.Operate
import strage.IntegerRegister
import strage.Memory
import strage.Register
import interpreter.{BigEndianInterpreter=>I}
import tomorrow.ver1.ImmediateOperandOpcode
import interpreter.BigEndianInterpreter

class Add extends ThreeRegisterOperandOpcode(0x00, 0x20) {
	protected def apply(operand: Operand, programCounter: IntegerRegister, registers: Map[String, Register], memory: Memory) = {
	    operand.rd.bytes = BigEndianInterpreter interpretAsByteArray ((BigEndianInterpreter.interpretAsSignedInteger(operand.rs)) + (BigEndianInterpreter interpretAsSignedInteger operand.rt))
	    programCounter.data += 4
	}
}
class Sub extends ThreeRegisterOperandOpcode(0x00, 0x22) {
	protected def apply(operand: Operand, programCounter: IntegerRegister, registers: Map[String, Register], memory: Memory) = {
	    operand.rd.bytes = BigEndianInterpreter interpretAsByteArray ((BigEndianInterpreter.interpretAsSignedInteger(operand.rs)) - (BigEndianInterpreter interpretAsSignedInteger operand.rt))
	    programCounter.data += 4
	}
}
class Mul extends ThreeRegisterOperandOpcode(0x00, 0x18) {
	protected def apply(operand: Operand, programCounter: IntegerRegister, registers: Map[String, Register], memory: Memory) = {
	    val result: Long = (BigEndianInterpreter.interpretAsSignedInteger(operand.rs)) * (BigEndianInterpreter interpretAsSignedInteger operand.rt)
	    val tmp: Int = ((result << 32) >> 32) toInt;
	    registers("LO").bytes = BigEndianInterpreter interpretAsByteArray (tmp)
	    registers("HI").bytes = BigEndianInterpreter interpretAsByteArray (result >> 32)
	    programCounter.data += 4
	}
}
class Div extends ThreeRegisterOperandOpcode(0x00, 0x1A) {
	protected def apply(operand: Operand, programCounter: IntegerRegister, registers: Map[String, Register], memory: Memory) = {
	    registers("LO").bytes = BigEndianInterpreter interpretAsByteArray ((BigEndianInterpreter.interpretAsSignedInteger(operand.rs)) / (BigEndianInterpreter interpretAsSignedInteger operand.rt))
	    registers("HI").bytes = BigEndianInterpreter interpretAsByteArray ((BigEndianInterpreter.interpretAsSignedInteger(operand.rs)) % (BigEndianInterpreter interpretAsSignedInteger operand.rt))
	    programCounter.data += 4
	}
}
class Addi extends ImmediateOperandOpcode(0x08) {
	protected def apply(operand: Operand, programCounter: IntegerRegister, registers: Map[String, Register], memory: Memory) = {
	    operand.rt.bytes = BigEndianInterpreter interpretAsByteArray ((BigEndianInterpreter.interpretAsSignedInteger(operand.rs)) + operand.constant) 
	    programCounter.data += 4
	}
}