

#Область ОбработчикиСобытий

Процедура ОбработкаПолученияДанныхВыбора(ДанныеВыбора, Параметры, СтандартнаяОбработка)
	
	ИспользоватьСтрахование = ПолучитьФункциональнуюОпцию("уатИспользоватьСтрахование_уэ");
	
	ДанныеВыбора = Новый СписокЗначений();
	ДанныеВыбора.Добавить(Перечисления.уатТипыВнешнихСистем.СистемаМониторинга);
	ДанныеВыбора.Добавить(Перечисления.уатТипыВнешнихСистем.ПроцессинговыйЦентр);
	ДанныеВыбора.Добавить(Перечисления.уатТипыВнешнихСистем.СистемаВзиманияПлаты);
	ДанныеВыбора.Добавить(Перечисления.уатТипыВнешнихСистем.СервисШтрафов);
	ДанныеВыбора.Добавить(Перечисления.уатТипыВнешнихСистем.СервисПарковок);
	Если ИспользоватьСтрахование Тогда
		ДанныеВыбора.Добавить(Перечисления.уатТипыВнешнихСистем.СервисСтрахования);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти
