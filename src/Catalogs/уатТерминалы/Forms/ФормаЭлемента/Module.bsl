
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	уатЗащищенныеФункцииСервер.уатСправочникФормаЭлементаПриСозданииНаСервере(Отказ, СтандартнаяОбработка, Объект, ЭтотОбъект, ДопПараметрыОткрытие);
	Если Отказ тогда
		Возврат;
	КонецЕсли;
	
	ОбновитьНадписьРазрешенныеТипыТС();
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	уатЗащищенныеФункцииКлиент.уатСправочникФормаЭлементаПриОткрытии(Отказ, ДопПараметрыОткрытие);
	Если Отказ Тогда
		Возврат;
	КонецЕсли;
	
	Если Не ВладелецФормы = Неопределено И ВладелецФормы.Имя = "ТерминалыПункта" Тогда 
		Элементы.Владелец.Видимость = Ложь;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти


#Область ОбработчикиСобытийЭлементовТаблицыФормы_РазрешенныеТипыТС

&НаКлиенте
Процедура РазрешенныеТипыТСТипТСНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	ФормаВыбора = ПолучитьФорму("Справочник.уатТипыТС.ФормаВыбора",, Элемент);
	
	ЭлементОтбора                  = ФормаВыбора.Список.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ЭлементОтбора.ЛевоеЗначение    = Новый ПолеКомпоновкиДанных("Ссылка");
	ЭлементОтбора.ВидСравнения     = ВидСравненияКомпоновкиДанных.ВСписке;
	ЭлементОтбора.ПравоеЗначение   = ПолучитьДоступныеТипыТС(Объект.Владелец);
	ЭлементОтбора.РежимОтображения = РежимОтображенияЭлементаНастройкиКомпоновкиДанных.Недоступный;
	ЭлементОтбора.Использование    = Истина;
	
	ФормаВыбора.Открыть();
	
КонецПроцедуры

&НаКлиенте
Процедура РазрешенныеТипыТСТипТСАвтоПодбор(Элемент, Текст, ДанныеВыбора, ПараметрыПолученияДанных, Ожидание, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	ДанныеВыбора = ПолучитьСписокВыбораДоступныхТиповТС(Объект.Владелец, Текст);
	
КонецПроцедуры

&НаКлиенте
Процедура РазрешенныеТипыТСТипТСОкончаниеВводаТекста(Элемент, Текст, ДанныеВыбора, ПараметрыПолученияДанных, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	ДанныеВыбора = ПолучитьСписокВыбораДоступныхТиповТС(Объект.Владелец, Текст);
	
КонецПроцедуры

#КонецОбласти


#Область СлужебныеПроцедурыИФункции

&НаСервереБезКонтекста
Функция ПолучитьДоступныеТипыТС(ПунктНазначения)
	
	Запрос = Новый Запрос();
	Запрос.УстановитьПараметр("ПунктНазначения", ПунктНазначения);
	
	Запрос.Текст = ?(ПунктНазначения.РазрешенныеТипыТС.Количество() > 0,"ВЫБРАТЬ РАЗРЕШЕННЫЕ РАЗЛИЧНЫЕ
	                                                                   |	уатПунктыНазначенияРазрешенныеТипыТС.ТипТС КАК ТипТС
	                                                                   |ИЗ
	                                                                   |	Справочник.уатПунктыНазначения.РазрешенныеТипыТС КАК уатПунктыНазначенияРазрешенныеТипыТС
	                                                                   |ГДЕ
	                                                                   |	уатПунктыНазначенияРазрешенныеТипыТС.Ссылка = &ПунктНазначения",
	"ВЫБРАТЬ РАЗРЕШЕННЫЕ РАЗЛИЧНЫЕ
	|	уатТипыПунктовРазрешенныеТипыТС.ТипТС КАК ТипТС
	|ИЗ
	|	Справочник.уатТипыПунктов.РазрешенныеТипыТС КАК уатТипыПунктовРазрешенныеТипыТС
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Справочник.уатПунктыНазначения КАК уатПунктыНазначения
	|		ПО уатТипыПунктовРазрешенныеТипыТС.Ссылка = уатПунктыНазначения.ТипПункта
	|		И уатПунктыНазначения.Ссылка = &ПунктНазначения");
	
	Возврат Запрос.Выполнить().Выгрузить().ВыгрузитьКолонку("ТипТС");
	
КонецФункции // ПолучитьДоступныеТипыТС()

&НаСервереБезКонтекста
Функция ПолучитьСписокВыбораДоступныхТиповТС(ПунктНазначения, Текст)
	
	СписокВыбора = Новый СписокЗначений();
	
	Запрос = Новый Запрос();
	Запрос.УстановитьПараметр("ПунктНазначения", ПунктНазначения);
	Запрос.УстановитьПараметр("СтрокаПодбора",   "" + Текст + "%");
	
	Запрос.Текст = ?(ПунктНазначения.РазрешенныеТипыТС.Количество() > 0,
	"ВЫБРАТЬ РАЗРЕШЕННЫЕ РАЗЛИЧНЫЕ
	|	уатПунктыНазначенияРазрешенныеТипыТС.ТипТС КАК Ссылка,
	|	уатПунктыНазначенияРазрешенныеТипыТС.ТипТС.Наименование КАК Наименование
	|ИЗ
	|	Справочник.уатПунктыНазначения.РазрешенныеТипыТС КАК уатПунктыНазначенияРазрешенныеТипыТС
	|ГДЕ
	|	уатПунктыНазначенияРазрешенныеТипыТС.Ссылка = &ПунктНазначения
	|	И уатПунктыНазначенияРазрешенныеТипыТС.ТипТС.Наименование ПОДОБНО &СтрокаПодбора",
	"ВЫБРАТЬ РАЗРЕШЕННЫЕ РАЗЛИЧНЫЕ
	|	уатТипыПунктовРазрешенныеТипыТС.ТипТС КАК Ссылка,
	|	уатТипыТС.Наименование КАК Наименование
	|ИЗ
	|	Справочник.уатТипыПунктов.РазрешенныеТипыТС КАК уатТипыПунктовРазрешенныеТипыТС
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Справочник.уатПунктыНазначения КАК уатПунктыНазначения
	|		ПО уатТипыПунктовРазрешенныеТипыТС.Ссылка = уатПунктыНазначения.ТипПункта
	|			И (уатПунктыНазначения.Ссылка = &ПунктНазначения)
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Справочник.уатТипыТС КАК уатТипыТС
	|		ПО уатТипыПунктовРазрешенныеТипыТС.ТипТС = уатТипыТС.Ссылка
	|ГДЕ
	|	уатТипыТС.Наименование ПОДОБНО &СтрокаПодбора");
	
	Выборка = Запрос.Выполнить().Выбрать();
	Пока Выборка.Следующий() Цикл 
		врПозицияОтсечения = СтрДлина(Текст);
		тПредставление = Новый ФорматированнаяСтрока(
			Новый ФорматированнаяСтрока(Лев(Выборка.Наименование, врПозицияОтсечения),, ЦветаСтиля.уатЦветТекстаПриАвтоподборе), 
			Новый ФорматированнаяСтрока(Прав(Выборка.Наименование, СтрДлина(Выборка.Наименование)-врПозицияОтсечения)));
		СписокВыбора.Добавить(Выборка.Ссылка, тПредставление);
	КонецЦикла;
	
	Возврат СписокВыбора;
	
КонецФункции // ПолучитьСписокВыбораДоступныхТиповТС()

&НаСервере
Процедура ОбновитьНадписьРазрешенныеТипыТС()
	
	СтрокаРазрешенныеТипыТС  = "";
	НадписьРазрешенныеТипыТС = уатОбщегоНазначения.ОбновитьНадписьРазрешенныеТипыТС(Объект.Владелец, СтрокаРазрешенныеТипыТС);
	
	Элементы.РазрешенныеТипыТС.Видимость = ЗначениеЗаполнено(СтрокаРазрешенныеТипыТС);
	
КонецПроцедуры

#КонецОбласти
