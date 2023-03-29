
var _my_data = [
	{
		name: "player data",
		location: "town7",
		level: 5,
		experience: 230948,
		character_name: "cool guy"
	},
	{
		name: "inventory data",
		items: [
			{
				name: "sword",
				count: 1,
				worth: 500,
				weight: 10
			},
						{
				name: "buckler",
				count: 1,
				worth: 200,
				weight: 4
			},
						{
				name: "cloak",
				count: 1,
				worth: 7,
				weight: 0.6
			}
		]
	}
];

var _json_string = json_stringify(_my_data);
var _file = file_text_open_write("did_this_work.txt");
file_text_write_string(_file, _json_string);
file_text_close(_file);

var _file_read = file_text_open_read("read_data.txt");
var _read_string = file_text_read_string(_file_read);
data_maybe = json_parse(_read_string);
file_text_close(_file_read);
