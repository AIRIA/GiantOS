<center><font color="orange">GiantOS</font></center>  
===

**DATE:2013/12/12 10:45:11**


----------

常规通讯的协议 
>socket服务器返回错误信息的统一结构

	{
		route:'error_msg',
		msg:'服务器返回的详细错误信息'
	}


----------


>老师登录进来发送的创建房间的命令

	{
		type:'cmd'
		route:'com.giant.vo::Room'
		roomId:'从页面获取'
	}

>学生登录进来发送的命令  

	{
		name:'学生姓名',
		id:'学生ID',
		roomId:'房间号',
		type:'msg',
		route:'com.giant.vo::Person'
	}


>获取房间在线人数信息 
	
	{
		route:"get_room_info",
		total:0,
		student:[{
			name:'学生名字',
			id:'学生的ID'
		},...]
	}

>PPT信息

	{
		pageId:'ppt当前页码',
		source:'ppt图片路径',
		name:'ppt名称',
		roomId:'房间号',
		route:'get_ppt_info'
	}

>获取学生id

	{
		route:'student_info'
		name:'姓名',
		id:'学生ID'
	}

>学生请求发言

	{
		route:'hands_up',
		id:'学生id',
		type:'ask'
	}

>学生登录进来

	{
		route:'student_login',
		id:'学生id',
		name:'学生姓名'
	}

>学生登出

	{
		route:'studetn_logout',
		id:'学生id',
		name:'学生姓名'
	}