#蘋果日報財經版新聞擷取機器人
###Little parser for getting finance news from apply daily, Taiwan.

This parser would get today finance news titles and pictures from Apple Dailay Inc.<br>
Becareful！ This parser would only get one day news. To getting more days, please using scheduling machine to execute this
programme every single day.<br>
<br>
*The news parsed from this parser are shown in Traditional Chinese.*<br>

##Require

1. Ruby-2.0 || Maybe Ruby-1.9 could run<br>
2. Rubygems-current<br>
3. Nokogiri<br>
4. Open-uri<br>
5. Active-records<br>
6. MySQL-server<br>
7. NetWork<br>
8. YAML<br>
9. perfect print<br>

##Data Schema

###Catalog
<table>
  <tr>
    <td>column name</td><td>name</td><td>kind</td><td>create_at</td><td>updated_at</td>
  </tr>
  <tr>
    <td>data type</td><td>string</td><td>integer</td><td>datetime</td><td>datetime</td>
  </tr>
</table>
<strong>:kind => limit:1, null:false</strong>
###NewsTable

<table>
  <tr>
    <td>column name</td><td>log_date</td><td>picture_address</td><td>news_title</td><td>news_address</td><td>serial</td>
  </tr>
  <tr>
    <td>data type</td><td>date</td><td>string</td><td>string</td><td>string</td><td>integer</td>
  </tr>
</table>
<strong>:log_id,:oil_id => null:false</strong>

##Install

* Build the development database first<br>
* Create a table called "NewsTable"<br>
* Change the password and username in "database.yml" matching your own mysql server<br>
* Change the path of your "database.yml" in "news.rb" to ensure that can connect to your database<br>
* Execute the news.rb and then you can get the latest finance news from apple daily<br>
* If you would like to make your programme execute every day, please checkout [this tutorial](http://dylandychat.blogspot.tw/2013/09/ubuntu-1304-cron.html).//Note that the tutorial was written in Chinese.

##Todo

There might be some "/" in the title of the news, this would cause the parser error.<br>
To prevent the error, regular expresion would make the parser work perfectly.<br>
Just need some time to do so.

##Data Resource

[台灣蘋果日報財經新聞](http://www.appledaily.com.tw/appledaily/article/finance)
