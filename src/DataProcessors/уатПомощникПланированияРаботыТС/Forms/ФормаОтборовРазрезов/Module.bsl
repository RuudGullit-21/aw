
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Автотест = Истина;
		Возврат;
	КонецЕсли;
	
	Параметры.Свойство("ИсточникПодбора",         ИсточникПодбора);
	Параметры.Свойство("НаименованиеСправочника", НаименованиеСправочника);
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	Если Автотест Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	
	Если ВладелецФормы = Неопределено Тогда
		ПоказатьПредупреждение(, НСтр("en='Immediate opening for this object is prohibited!';ru='Непосредственное открытие для данного объекта запрещено!'"), 10);
		Отказ = Истина;
		Возврат;
	КонецЕсли;
	
	ИнициализацияКомпоновщика();
	
КонецПроцедуры

&НаКлиенте
Процедура ПриЗакрытии(ЗавершениеРаботы)
	
	Если ЗавершениеРаботы Тогда 
		Возврат;
	КонецЕсли;
	
	СохранитьНастройки();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ВыполнитьЗапрос(Команда)
	
	Закрыть(ВыполнитьСервер());
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Функция ВыполнитьСервер()
	
	КомпоновщикМакета = Новый КомпоновщикМакетаКомпоновкиДанных;
	
	Макет = КомпоновщикМакета.Выполнить(
		ПолучитьИзВременногоХранилища(АдресСхемыКомпоновкиДанных),
		КомпНастроек.ПолучитьНастройки(),
		,
		,
		Тип("ГенераторМакетаКомпоновкиДанныхДляКоллекцииЗначений")
	);
	
	ПроцессорКомпоновки = Новый ПроцессорКомпоновкиДанных;
	ПроцессорКомпоновки.Инициализировать(Макет,,, Истина);
	
	ПроцессорВывода = Новый ПроцессорВыводаРезультатаКомпоновкиДанныхВКоллекциюЗначений;
	ТаблРезультат = ПроцессорВывода.Вывести(ПроцессорКомпоновки);
	
	Возврат ТаблРезультат.ВыгрузитьКолонку("Ссылка");
	
КонецФункции

&НаСервере
Процедура ИнициализацияКомпоновщика()
	
	СхемаКомпоновкиДанных = Новый СхемаКомпоновкиДанных;
	ИсточникДанных        = СхемаКомпоновкиДанных.ИсточникиДанных.Добавить();
	ИсточникДанных.Имя    = "ИсточникДанных";
	ИсточникДанных.ТипИсточникаДанных = "Local";
	
	НаборДанных = СхемаКомпоновкиДанных.НаборыДанных.Добавить(Тип("НаборДанныхЗапросСхемыКомпоновкиДанных"));
	НаборДанных.Имя                          = "ОсновнойНабор";
	НаборДанных.ИсточникДанных               = "ИсточникДанных";
	НаборДанных.АвтоЗаполнениеДоступныхПолей = Истина;
	
	НаборДанных.Запрос = "ВЫБРАТЬ
	|    //НаименованиеСправочника.Ссылка КАК Ссылка
	|ИЗ
	|    Справочник.//НаименованиеСправочника КАК //НаименованиеСправочника";
	
	НаборДанных.Запрос = СтрЗаменить(НаборДанных.Запрос,"//НаименованиеСправочника", НаименованиеСправочника);
	
	ПолеНоменклатуры = НаборДанных.Поля.Добавить(Тип("ПолеНабораДанныхСхемыКомпоновкиДанных"));
	ПолеНоменклатуры.Заголовок    = "Ссылка";
	ПолеНоменклатуры.ПутьКДанным  = "Ссылка";
	ПолеНоменклатуры.Поле         = "Ссылка";
	
	НастройкиКомпоновкиДанных = СхемаКомпоновкиДанных.НастройкиПоУмолчанию;
	
	ГруппировкаНоменклатуры = НастройкиКомпоновкиДанных.Структура.Добавить(Тип("ГруппировкаКомпоновкиДанных"));
	
	ВыбранноеПоле = ГруппировкаНоменклатуры.Выбор.Элементы.Добавить(Тип("ВыбранноеПолеКомпоновкиДанных"));
	ВыбранноеПоле.Заголовок     = "Ссылка";
	ВыбранноеПоле.Использование = Истина;
	ВыбранноеПоле.Поле          = Новый ПолеКомпоновкиДанных("Ссылка");
	
	АдресСхемыКомпоновкиДанных = ПоместитьВоВременноеХранилище(СхемаКомпоновкиДанных, УникальныйИдентификатор);
	
	КомпНастроек.Инициализировать(Новый ИсточникДоступныхНастроекКомпоновкиДанных(АдресСхемыКомпоновкиДанных));
	КомпНастроек.ЗагрузитьНастройки(СхемаКомпоновкиДанных.НастройкиПоУмолчанию);
	
	ВосстановитьНастройки();
	
КонецПроцедуры

&НаСервере
Процедура ВосстановитьНастройки()
	
	Если ПравоДоступа("СохранениеДанныхПользователя", Метаданные) Тогда 
		СтруктураНастроек = ХранилищеНастроекДанныхФорм.Загрузить(
			"Обработка.уатПомощникПланированияРаботыТС.Форма.ФормаОтборовРазрезов", 
			ИсточникПодбора
		);
		
	Иначе 
		СтруктураНастроек = Неопределено;
	КонецЕсли;
	
	Если Не ТипЗнч(СтруктураНастроек) = Тип("Структура") Тогда
		Возврат;
	КонецЕсли;
	
	Если СтруктураНастроек.Свойство("Отбор") Тогда 
		ВосстановитьНастройкиОтбора(СтруктураНастроек.Отбор, КомпНастроек.Настройки.Отбор.Элементы);
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ВосстановитьНастройкиОтбора(мсвНастроек, ЭлементыОтбора)
	
	Для Каждого ТекОтбор Из мсвНастроек Цикл 
		Если ТекОтбор.Свойство("Элементы") Тогда 
			НовОтбор = ЭлементыОтбора.Добавить(Тип("ГруппаЭлементовОтбораКомпоновкиДанных"));
			ЗаполнитьЗначенияСвойств(НовОтбор, ТекОтбор, "ТипГруппы, Использование");
			
			ВосстановитьНастройкиОтбора(ТекОтбор.Элементы, НовОтбор.Элементы);
			
		Иначе 
			НовОтбор = ЭлементыОтбора.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
			ЗаполнитьЗначенияСвойств(НовОтбор, ТекОтбор);
		КонецЕсли;
	КонецЦикла;
	
КонецПроцедуры

&НаСервере
Процедура СохранитьНастройки()
	
	Если Не ПравоДоступа("СохранениеДанныхПользователя", Метаданные) Тогда 
		Возврат;
	КонецЕсли;
	
	УстановитьПривилегированныйРежим(Истина);
	
	СтруктураНастроек = Новый Структура("Отбор", Новый Массив());
	
	ПолучитьНастройкиОтбора(СтруктураНастроек.Отбор, КомпНастроек.Настройки.Отбор.Элементы);
	
	ХранилищеНастроекДанныхФорм.Сохранить(
		"Обработка.уатПомощникПланированияРаботыТС.Форма.ФормаОтборовРазрезов", 
		ИсточникПодбора, 
		СтруктураНастроек
	);
	
КонецПроцедуры

&НаСервере
Процедура ПолучитьНастройкиОтбора(мсвНастроек, ЭлементыОтбора)
	
	Для Каждого ТекОтбор Из ЭлементыОтбора Цикл 
		стрОтбор = Новый Структура();
		
		Если ТипЗнч(ТекОтбор) = Тип("ГруппаЭлементовОтбораКомпоновкиДанных") Тогда 
			стрОтбор.Вставить("ТипГруппы",     ТекОтбор.ТипГруппы);
			стрОтбор.Вставить("Элементы",      Новый Массив());
			стрОтбор.Вставить("Использование", ТекОтбор.Использование);
			
			ПолучитьНастройкиОтбора(стрОтбор.Элементы, ТекОтбор.Элементы);
			
		Иначе 
			стрОтбор.Вставить("ЛевоеЗначение",  ТекОтбор.ЛевоеЗначение);
			стрОтбор.Вставить("ВидСравнения",   ТекОтбор.ВидСравнения);
			стрОтбор.Вставить("ПравоеЗначение", ТекОтбор.ПравоеЗначение);
			стрОтбор.Вставить("Использование",  ТекОтбор.Использование);
		КонецЕсли;
		
		мсвНастроек.Добавить(стрОтбор);
	КонецЦикла;
	
КонецПроцедуры

#КонецОбласти
