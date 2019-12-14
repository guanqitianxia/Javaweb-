<%@ page language="java" contentType="text/html; charset=utf-8"
    pageEncoding="utf-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<title>Insert title here</title>
</head>
<body>
<h2>图片显示和上传</h2>
  <form name="upform" action="UploadServlet" method="POST" enctype="multipart/form-data">     
     <input type="file" name="img" id="img" onchange="draw()"/><br>
     <canvas id="canvas"></canvas><br>    
     <input type="reset" />   
  </form>
  <img id="image" width="107" height="98"/></br>
<script>
function draw(){
	var image;
    let file = document.querySelector('input[type=file]').files[0]  // 获取选择的文件，这里是图片类型
    var imagepath=document.getElementById('img').value;
    let reader = new FileReader()
    reader.readAsDataURL(file) //读取文件并将文件以URL的形式保存在resulr属性中 base64格式
    reader.onload = function(e) { // 文件读取完成时触发 
        let result = e.target.result // base64格式图片地址 
        image = new Image();
        image.src = result // 设置image的地址为base64的地址 
        image.onload = function(){ 
            var canvas = document.querySelector("#canvas"); 
            var context = canvas.getContext("2d"); 
            canvas.width = 100; // 设置canvas的画布宽度为图片宽度 image.width to 100px;
            canvas.height = 100; 
            context.drawImage(image, 0, 0, 100, 100) // 在canvas上绘制图片 
            //let dataUrl = canvas.toDataURL('image/jpeg', 0.92) // 0.92为压缩比，可根据需要设置，设置过小会影响图片质量 
            // dataUrl 为压缩后的图片资源，可将其上传到服务器 
        } 
    }
    //alert(imagepath);
    document.getElementById('image').src=imagepath;
}

</script>
</body>
</html>