GiantOS
=======

live teach

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
		student:[json]
	}