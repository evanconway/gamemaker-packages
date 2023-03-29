const fs = require('fs');

/*
	{
		'name': 'greet_tutorial_person2',
		'text': {
			'eng': 'Are you good or bad?',
			'jap': 'あなたは良いですか悪いですか？',
			'ger': 'Bist du gut oder schlecht?'
		},
		'options': [
			{
				'text': {
					'eng': 'good',
					'jap': '良い',
					'ger': 'gut'
				},
				'goto': 'good'
			},
			{
				'text': {
					'eng': 'bad',
					'jap': '悪い',
					'ger': 'schlecht'
				},
				'goto': 'bad'
			}
		],
		'goto': ""
		'is_end': false
	},
*/

const VALID_STEP_FIELDS = ["name", "text", "options", "goto", "is_end"];
const VALID_LANGUAGES = ["eng", "zho", "fre", "ger", "ita", "jpn", "kor", "pol", "por", "rus", "spa"];
const VALID_OPTION_FIELDS = ["text", "goto"];

const AUTO_NAME_PREFIX = "auto_name_";

/**
 * @param {String} pathToDirectory path to directory with dialog files
 * @returns {any[]} array of each parsed json file
 */
const readJsonAtDirectory = (pathToDirectory) => {
    const result = [];
    fs.readdirSync(pathToDirectory).forEach(fileName => {
        if (!fileName.endsWith(".json")) return;
        try {
            const fileData = fs.readFileSync(`${pathToDirectory}/${fileName}`, 'utf-8');
            const parsedJson = JSON.parse(fileData, 'utf-8');
            result.push(parsedJson);
        } catch (err) {
            console.error(err);
        }
    });
    return result;
};

const makeDialogStepValid = (dialogStep) => {
    if (!dialogStep || typeof dialogStep !== 'object') throw new Error("step is not json object");

    // ensure only valid field names are in object
    Object.keys(dialogStep).forEach(key => {
        if (!VALID_STEP_FIELDS.includes(key)) throw new Error(`invalid field "${key}" found`);
    })
    
    // ensure auto name was not used manually
    if (typeof(dialogStep.name) == 'string' && dialogStep.name.startsWith(AUTO_NAME_PREFIX)) throw new Error(`names may not start with ${AUTO_NAME_PREFIX}`);

    return null;
}

/**
 * 
 * @param {any[][]} json array of array of json, error will be thrown if not a 2D array
 */
const getValidStepsFromJson = (json) => {
    const result = [];
    if (!Array.isArray(json)) throw new Error("json must be array of array");
    json.forEach(jsonArr => {
        if (!Array.isArray(jsonArr)) throw new Error("each dialog file must be array of step objects");
        jsonArr.forEach(step => result.push(makeDialogStepValid(step)));
    });
    return result;
};

const json = readJsonAtDirectory("c:/Users/Evan/Documents/GameMakerStudio2/gamemaker-packages/dialogbuilder/dialog");

const validSteps = getValidStepsFromJson(json);
