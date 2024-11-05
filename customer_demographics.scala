import org.apache.spark.sql.SparkSession
import org.apache.spark.sql.functions._
import scala.xml.XML
import java.math.{BigDecimal => JavaBigDecimal}
import java.lang.{Byte => JavaByte}
import java.sql.Date
import org.apache.spark.sql.types.{DateType}

val spark = SparkSession.builder.enableHiveSupport().getOrCreate()
import spark.implicits._

case class CustomerDemo(icustId: Int, iPurchYTD: JavaBigDecimal, firstPurDt : Date, bDate : Date, marStatus : String, yIncome : String, gnder : String, totChildren : JavaByte, noChildHome : JavaByte, educatn : String, occupatn : String, homeOwnFlag : String, noCarOwnd : JavaByte, commDist : String, crtDate : Date) extends java.io.Serializable

def createCustDemo(custId: Int, demo:String) : CustomerDemo = {
	val sdf = new java.text.SimpleDateFormat("yyyy-MM-dd'Z'")

	val node = XML.loadString(demo)

	val purchaseTD = (node \\ "IndividualSurvey" \\ "TotalPurchaseYTD").text
	val kountChildren = (node \\ "IndividualSurvey" \\ "TotalChildren").text
	val childAtHome = (node \\ "IndividualSurvey" \\ "NumberChildrenAtHome").text
	val carsOwned = (node \\ "IndividualSurvey" \\ "NumberCarsOwned").text

	def parseDate(ds: String): Date = {
		try {
			if (ds != null) new Date(sdf.parse(ds).getTime) else null
		} catch {
			case _ : Throwable => null		
		}
	}

	CustomerDemo(
		custId,
		if (purchaseTD ==null || purchaseTD.isEmpty) null else new JavaBigDecimal(purchaseTD),
		parseDate((node \\ "IndividualSurvey" \\ "DateFirstPurchase").text),
		parseDate((node \\ "IndividualSurvey" \\ "BirthDate").text),
		(node \\ "IndividualSurvey" \\ "MaritalStatus").text,
		(node \\ "IndividualSurvey" \\ "YearlyIncome").text,
		(node \\ "IndividualSurvey" \\ "Gender").text,
		if (kountChildren ==null || kountChildren.isEmpty) null else kountChildren.toByte,
		if (childAtHome ==null || childAtHome.isEmpty) null else childAtHome.toByte,
		(node \\ "IndividualSurvey" \\ "Education").text,
		(node \\ "IndividualSurvey" \\ "Occupation").text,
		(node \\ "IndividualSurvey" \\ "HomeOwnerFlag").text,
		if (carsOwned ==null || carsOwned.isEmpty) null else carsOwned.toByte,
		(node \\ "IndividualSurvey" \\ "CommuteDistance").text,
		new Date(System.currentTimeMillis)
	)
}

val customerRDD = spark.sql("SELECT CustomerID, Demographics FROM store_stage.customer").cache()
val projDF = customerRDD.select("CustomerID", "Demographics")
val projRDD = projDF.as[(Int, String)].rdd.map{ case (id, xml) => createCustDemo(id, xml) }
val customerDemoDF = projRDD.toDF()

val existingDemo = spark.sql("SELECT * FROM store.customer_demo")

// val existingDemo = sqlContext.read.table("store.customer_demo")
val schema = existingDemo.schema

//full outer join
val outerJon = existingDemo.join(customerDemoDF, $"icustId" === $"customerid", "outer").
	select(when($"icustId".isNull, $"customerid").otherwise($"icustId").as("customerid"),
			when($"iPurchYTD".isNull, $"totalpurchaseytd").otherwise($"iPurchYTD").as("totalpurchaseytd"),
			when($"firstPurDt".isNull, $"datefirstpurchase").otherwise($"firstPurDt").as("datefirstpurchase"),
			when($"bDate".isNull, $"birthdate").otherwise($"bDate").as("birthdate"),
			when($"marStatus".isNull, $"maritalstatus").otherwise($"marStatus").as("maritalstatus"),
			when($"yIncome".isNull, $"yearlyincome").otherwise($"yIncome").as("yearlyincome"),
			when($"gnder".isNull, $"gender").otherwise($"gnder").as("gender"),
			when($"totChildren".isNull, $"totalchildren").otherwise($"totChildren").as("totalchildren"),
			when($"noChildHome".isNull, $"numberchildrenathome").otherwise($"noChildHome").as("numberchildrenathome"),
			when($"educatn".isNull, $"education").otherwise($"educatn").as("education"),
			when($"occupatn".isNull, $"occupation").otherwise($"occupatn").as("occupation"),
			when($"homeOwnFlag".isNull, $"homeownerflag").otherwise($"homeOwnFlag").as("homeownerflag"),
			when($"noCarOwnd".isNull, $"numbercarsowned").otherwise($"noCarOwnd").as("numbercarsowned"),
			when($"commDist".isNull, $"commutedistance").otherwise($"commDist").as("commutedistance"),
			when($"crtDate".isNull, $"create_date").otherwise($"crtDate").as("create_date"))

//inner
val innerDF = existingDemo.join(customerDemoDF, $"icustId" === $"customerid").select($"icustId",$"iPurchYTD",$"firstPurDt",$"bDate",$"marStatus",$"yIncome",$"gnder",$"totChildren",$"noChildHome",$"educatn",$"occupatn",$"homeOwnFlag",$"noCarOwnd",$"commDist", lit(new Date(System.currentTimeMillis)).as("createDate").cast(DateType))

val df = innerDF.unionAll(outerJon)


// Assuming toBeArchived contains the logic to select records that need archiving
val toBeArchived = spark.sql("SELECT * FROM newTable WHERE someCondition")  // Define your condition
toBeArchived.write.mode("append").insertInto("store.customer_demo_history")

// Write output to a temporary table
df.write.mode("overwrite").saveAsTable("store.temp_customer_demo")

// Drop the original table and rename the temporary table to the original
spark.sql("DROP TABLE store.customer_demo")
spark.sql("ALTER TABLE store.temp_customer_demo RENAME TO store.customer_demo")











