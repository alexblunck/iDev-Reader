<?php

function fetch_rss_feed($url, $numposts) {
			
     $rss = simplexml_load_file($url);  //Fetch RSS with simplexml
            
     $rss_array = array();
     foreach ($rss->channel->item as $item) {
          if ($numposts == 0) {
               break;
          } else {
               $link = (string) $item->link;  //Link to post
               $title = (string) $item->title;  //Title
    				
               //Convert title into ISO-8859-1 (solves special symbol problem)
               $title = iconv( "UTF-8", "ISO-8859-1//TRANSLIT", $title);		
    			
               //Get the date
               $pubdate = strtotime($item->pubDate);
               $propertime = gmdate('F jS Y, H:i', $pubdate);  //Customize this to your liking
    			
               //Description or post summary	
               $desc = $item->description;
    				
               // turn URLs into hyperlinks
               $desc = preg_replace("/(http:\/\/)(.*?)\/([\w\.\/\&\=\?\-\,\:\;\#\_\~\%\+]*)/", "<a href=\"\\0\">\\0</a>", $desc);
                    
               //Converts description into ISO-8859-1 (solves special symbols problem)
               $desc = iconv( "UTF-8", "ISO-8859-1//TRANSLIT", $desc);
                    
               //Shorten down description based on word count
               $shortdesc = ''; // Must be reset each time
               $token = strtok($desc, " ");
               $numwords = 55;  //The number of words
               $i = 0;
               while ($i < $numwords) {
                    if ($token != false) {
                         $shortdesc .= "$token ";
                         $token = strtok(" ");
                    }
                    $i++;
               }
                    
               //Adds a (...) at the end. Remove the next line if you don't want it
               $shortdesc .= " (...)";

               //Store into array
               $rss_item = array(
                    'title' => $title,
                    'date' => $propertime,
                    'link' => $link,
                    'descr' => $shortdesc
               );
               array_push($rss_array, $rss_item);

               $numposts--;
          }
     }
     //return array
     return $rss_array;
}
?>