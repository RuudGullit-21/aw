
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	уатЗащищенныеФункцииСервер.уатСправочникФормаЭлементаПриСозданииНаСервере(Отказ, СтандартнаяОбработка, Объект, ЭтотОбъект, ДопПараметрыОткрытие);
	Если Отказ тогда
		Возврат;
	КонецЕсли;

	Элементы.ТипСистемы.СписокВыбора.Очистить();
	Элементы.ТипСистемы.СписокВыбора.Добавить(Перечисления.уатТипыВнешнихСистем.ПроцессинговыйЦентр);
	Элементы.ТипСистемы.СписокВыбора.Добавить(Перечисления.уатТипыВнешнихСистем.СистемаВзиманияПлаты);
	
	ИспользоватьСтрахование = ПолучитьФункциональнуюОпцию("уатИспользоватьСтрахование_уэ");
	Если ИспользоватьСтрахование Тогда
		Элементы.ТипСистемы.СписокВыбора.Добавить(Перечисления.уатТипыВнешнихСистем.СервисСтрахования);
	КонецЕсли;

	ИспользоватьМониторинг = ПолучитьФункциональнуюОпцию("уатИспользоватьМониторинг");
	Если ИспользоватьМониторинг Тогда
		Элементы.ТипСистемы.СписокВыбора.Добавить(Перечисления.уатТипыВнешнихСистем.СистемаМониторинга);
	КонецЕсли;
	
	Если Объект.СоответствиеКолонок.Количество() = 0 Тогда
		ИнициализацияСоответствияКолонок();
	КонецЕсли;
	
	Если Параметры.Свойство("Режим") Тогда
		Если Параметры.Режим = 2 Тогда
			Элементы.Страницы.ТекущаяСтраница = Элементы.СтраницаЗагрузкаЗаправок;
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	уатЗащищенныеФункцииКлиент.уатСправочникФормаЭлементаПриОткрытии(Отказ, ДопПараметрыОткрытие);
	Если Отказ Тогда
		Возврат;
	КонецЕсли;
	
	УстановитьВидимостьДоступность();
	
КонецПроцедуры

#КонецОбласти


#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ТипСистемыПриИзменении(Элемент)
	
	Если Объект.ТипСистемы = ПредопределенноеЗначение("Перечисление.уатТипыВнешнихСистем.СистемаВзиманияПлаты")
		И уатОбщегоНазначенияПовтИсп.ВариантПоставкиСТД() Тогда
		Объект.ТипСистемы = ПредопределенноеЗначение("Перечисление.уатТипыВнешнихСистем.ПроцессинговыйЦентр");
		ТекстНстр = Нстр("ru = 'Интеграция с системой взимания платы ""Платон"" и ""Автодор"" не доступна в текущей версии программы. Интеграция доступна в версии ПРОФ и КОРП'");
		ПоказатьПредупреждение(, ТекстНстр);
		Возврат;
	КонецЕсли;
	
	Объект.ГлубинаПоискаПЛДоВыезда							 = Неопределено;
	Объект.ГлубинаПоискаПЛПослеВозвращения					 = Неопределено;
	Объект.ТолькоПроверенные								 = Неопределено;
	Объект.ОбрабатыватьРассчитанныеПутевыеЛисты				 = Неопределено;
	Объект.ПересчитатьПутевыеЛисты							 = Неопределено;
	Объект.КомментироватьХодВыполнения						 = Неопределено;
	Объект.ПроводитьСозданныеЗаправкиГСМ					 = Неопределено;
	Объект.СоздаватьСливыДляОтрицательныхЗаправок			 = Неопределено;
	Объект.ПроверятьНаличееДублейПоСозданнымРанееДокументам	 = Неопределено;
	Объект.ОткрыватьФормыЗаписанныхЗаправок					 = Неопределено;
	Объект.ТипСоответствияКолонок = 1;

	УстановитьВидимостьДоступность();
	ИнициализацияСоответствияКолонок();
	
КонецПроцедуры

&НаКлиенте
Процедура ТипСоответствияКолонокПриИзменении(Элемент)
	ОчиститьНомераИменаКолонок();
	УстановитьВидимостьДоступность();
КонецПроцедуры

&НаКлиенте
Процедура ВнешняяСистемаПриИзменении(Элемент)
	
	Если Объект.ТипСистемы = ПредопределенноеЗначение("Перечисление.уатТипыВнешнихСистем.СистемаВзиманияПлаты")
		И уатОбщегоНазначенияПовтИсп.ВариантПоставкиСТД() Тогда
		Объект.ТипСистемы = ПредопределенноеЗначение("Перечисление.уатТипыВнешнихСистем.ПроцессинговыйЦентр");
		ТекстНстр = Нстр("ru = 'Интеграция с системой взимания платы ""Платон"" и ""Автодор"" не доступна в текущей версии программы. Интеграция доступна в версии ПРОФ и КОРП'");
		ПоказатьПредупреждение(, ТекстНстр);
		Возврат;
	КонецЕсли;

	Объект.ГлубинаПоискаПЛДоВыезда							 = Неопределено;
	Объект.ГлубинаПоискаПЛПослеВозвращения					 = Неопределено;
	Объект.ТолькоПроверенные								 = Неопределено;
	Объект.ОбрабатыватьРассчитанныеПутевыеЛисты				 = Неопределено;
	Объект.ПересчитатьПутевыеЛисты							 = Неопределено;
	Объект.КомментироватьХодВыполнения						 = Неопределено;
	Объект.ПроводитьСозданныеЗаправкиГСМ					 = Неопределено;
	Объект.СоздаватьСливыДляОтрицательныхЗаправок			 = Неопределено;
	Объект.ПроверятьНаличееДублейПоСозданнымРанееДокументам	 = Неопределено;
	Объект.ОткрыватьФормыЗаписанныхЗаправок					 = Неопределено;
	Объект.ТипСоответствияКолонок = 1;

	УстановитьВидимостьДоступность();
	ИнициализацияСоответствияКолонок();
	
КонецПроцедуры

#КонецОбласти


#Область ОбработчикиСобытийЭлементовТаблицыФормыСоответствиеКолонок

&НаКлиенте
Процедура СоответствиеКолонокИспользованиеПриИзменении(Элемент)
	ТекСтрока = Элементы.СоответствиеКолонок.ТекущиеДанные;
	Если ЗначениеЗаполнено(ТекСтрока.ИмяКолонкиФайла) И НЕ ТекСтрока.Использование Тогда
		ТекСтрока.Использование = Истина;
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура СоответствиеКолонокИмяКолонкиФайлаПриИзменении(Элемент)
	ТекСтрока = Элементы.СоответствиеКолонок.ТекущиеДанные;
	Если ЗначениеЗаполнено(ТекСтрока.ИмяКолонкиФайла) И НЕ ТекСтрока.Использование Тогда
		ТекСтрока.Использование = Истина;
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура СоответствиеКолонокНомерКолонкиФайлаПриИзменении(Элемент)
	ТекСтрока = Элементы.СоответствиеКолонок.ТекущиеДанные;
	Если ЗначениеЗаполнено(ТекСтрока.НомерКолонкиФайла) И НЕ ТекСтрока.Использование Тогда
		ТекСтрока.Использование = Истина;
	КонецЕсли;
КонецПроцедуры

#КонецОбласти


#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ЗаполнитьПоШаблону(Команда)
	ЗаполнитьПоШаблонуСервер();
КонецПроцедуры

#КонецОбласти


#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура ОчиститьНомераИменаКолонок()
	Для Каждого ТекСтрока Из Объект.СоответствиеКолонок Цикл
		Если Объект.ТипСоответствияКолонок = 0 Тогда
			ТекСтрока.НомерКолонкиФайла = 0;
		Иначе
			ТекСтрока.ИмяКолонкиФайла = "";
		КонецЕсли;
	КонецЦикла;
КонецПроцедуры

&НаКлиенте
Процедура УстановитьВидимостьДоступность()
	
	флагПЦ = Объект.ТипСистемы = ПредопределенноеЗначение("Перечисление.уатТипыВнешнихСистем.ПроцессинговыйЦентр");
	Элементы.Страницы.ОтображениеСтраниц = ОтображениеСтраницФормы.ЗакладкиСверху;
	
	Элементы.ГруппаНастройкиДополнительноИнформация.Видимость = Истина;
	Если флагПЦ Тогда
		Элементы.ГруппаЗагрузкаЗаправок.Видимость	 = Истина;
		Элементы.ГруппаНастройки.Видимость			 = Истина;
	ИначеЕсли Объект.ТипСистемы = ПредопределенноеЗначение("Перечисление.уатТипыВнешнихСистем.СистемаВзиманияПлаты")
		ИЛИ Объект.ТипСистемы = ПредопределенноеЗначение("Перечисление.уатТипыВнешнихСистем.СервисСтрахования") Тогда
		Элементы.ГруппаЗагрузкаЗаправок.Видимость	 = Ложь;
		Элементы.ГруппаНастройки.Видимость			 = Истина;
		Элементы.Страницы.ОтображениеСтраниц = ОтображениеСтраницФормы.Нет; 
	ИначеЕсли Объект.ТипСистемы = ПредопределенноеЗначение("Перечисление.уатТипыВнешнихСистем.СистемаМониторинга") Тогда
		Элементы.ГруппаЗагрузкаЗаправок.Видимость	 = Истина;
		Элементы.ГруппаНастройки.Видимость			 = Ложь;
		Элементы.ГруппаНастройкиДополнительноИнформация.Видимость = Ложь;
	Иначе
		Элементы.ГруппаЗагрузкаЗаправок.Видимость	 = Ложь;
		Элементы.ГруппаНастройки.Видимость			 = Ложь;
		Элементы.Страницы.ОтображениеСтраниц		 = ОтображениеСтраницФормы.Нет;
	КонецЕсли;
	Элементы.ТолькоПроверенные.Видимость						 = флагПЦ;
	Элементы.СоздаватьСливыДляОтрицательныхЗаправок.Видимость	 = флагПЦ;
	Элементы.ФлажокКомментироватьХодВыполнения.Видимость		 = флагПЦ; 
	Элементы.ОткрыватьФормыЗаписанныхЗаправок.Видимость			 = флагПЦ;

	
	Элементы.ГруппаНастройки.Видимость          = НЕ Объект.Ссылка = ПредопределенноеЗначение("Справочник.уатПрофилиОбменаСВнешнимиСистемами.Роснефть");
	Элементы.УчитыватьНаценкиСкидки.Видимость   = Объект.Ссылка = ПредопределенноеЗначение("Справочник.уатПрофилиОбменаСВнешнимиСистемами.Роснефть");
	Элементы.СтраницаЗагрузкаДанныхПЦ.Видимость = НЕ (Объект.Ссылка = ПредопределенноеЗначение("Справочник.уатПрофилиОбменаСВнешнимиСистемами.ППР")
		ИЛИ Объект.Ссылка = ПредопределенноеЗначение("Справочник.уатПрофилиОбменаСВнешнимиСистемами.Лукойл")
		ИЛИ Объект.ТипСистемы = ПредопределенноеЗначение("Перечисление.уатТипыВнешнихСистем.СистемаМониторинга"));
		
	Элементы.ЗаполнитьПоШаблону.Видимость = Объект.Предопределенный;
	
	Если Объект.ТипСоответствияКолонок = 0 Тогда
		Элементы.СоответствиеКолонокИмяКолонкиФайла.Видимость = Истина;
		Элементы.СоответствиеКолонокНомерКолонкиФайла.Видимость = Ложь;
	Иначе
		Элементы.СоответствиеКолонокИмяКолонкиФайла.Видимость = Ложь;
		Элементы.СоответствиеКолонокНомерКолонкиФайла.Видимость = Истина;
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ИнициализацияСоответствияКолонок()
	
	Справочники.уатПрофилиОбменаСВнешнимиСистемами.ИнициализацияСоответствияКолонок(Объект);
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьПоШаблонуСервер()
	Если Объект.Ссылка = Справочники.уатПрофилиОбменаСВнешнимиСистемами.Газпромнефть Тогда
		Справочники.уатПрофилиОбменаСВнешнимиСистемами.ИнициализацияСоответствияКолонокГазпромнефть(Объект);
	ИначеЕсли Объект.Ссылка = Справочники.уатПрофилиОбменаСВнешнимиСистемами.ПлатонВыпискаОпераций Тогда
		Справочники.уатПрофилиОбменаСВнешнимиСистемами.ИнициализацияСоответствияКолонокПлатонВыпискаОпераций(Объект);
	ИначеЕсли Объект.Ссылка = Справочники.уатПрофилиОбменаСВнешнимиСистемами.ПлатонЛогистическийОтчет Тогда
		Справочники.уатПрофилиОбменаСВнешнимиСистемами.ИнициализацияСоответствияКолонокПлатонЛогистическийОтчет(Объект);
	ИначеЕсли Объект.Ссылка = Справочники.уатПрофилиОбменаСВнешнимиСистемами.Автодор Тогда  
		Справочники.уатПрофилиОбменаСВнешнимиСистемами.ИнициализацияСоответствияКолонокАвтодор(Объект);
	КонецЕсли;
КонецПроцедуры

#КонецОбласти

