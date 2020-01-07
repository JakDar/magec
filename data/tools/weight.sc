interp.load.ivy(
  "com.lihaoyi" %
    s"ammonite-shell_${scala.util.Properties.versionNumberString}" %
    ammonite.Constants.version,
  // "org.typelevel" % "mouse_2.12" % "0.20"
)

//todo:bcm
@
val shellSession = ammonite.shell.ShellSession()
// import mouse.boolean._
import shellSession._
import ammonite.ops._
import ammonite.shell._
import scala.io.Source
import java.io.File


val errorFile = new File( "./../pl/err.txt")
val correctFile = new File( "./../pl/corr.txt")



val errorSource = Source.fromFile(errorFile,"utf-8")
val correctSource = Source.fromFile(correctFile,"utf-8")


val correctLines = correctSource.getLines().take(100)//.map(_.split("").size)
val errorLines = errorSource.getLines().take(100)//.map(_.split("").size)

def printData(err:String,corr:String) = {
  println("====================Ok =====> Err==================================")
  println(corr)
  println(err)
  println(corr.split(" ").size,err.split(" ").size)
}

errorLines.zip(correctLines).foreach(printData _ tupled)

errorSource.close()
correctSource.close()
