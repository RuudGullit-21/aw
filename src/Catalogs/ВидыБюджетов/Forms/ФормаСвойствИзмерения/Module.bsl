
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если НЕ Параметры.Свойство("ТипИзмерения") Тогда
		Возврат;
	КонецЕсли;
		
	ТипИзмерения = Параметры.ТипИзмерения;
	Если ТипИзмерения = Перечисления.ТипыИзмеренийФинансовогоОтчета.Аналитика Тогда
		ВыбранныеЗначения.ТипЗначения = Параметры.ДополнительнаяИнформация.ТипЗначения;
		Заголовок = Строка(Параметры.ДополнительнаяИнформация) + ":";
		ВидАналитики = Параметры.ДополнительнаяИнформация;
	ИначеЕсли ТипИзмерения = Перечисления.ТипыИзмеренийФинансовогоОтчета.ИзмерениеРегистра
		И Параметры.ДополнительнаяИнформация = "Организация" Тогда
		ВыбранныеЗначения.ТипЗначения = Новый ОписаниеТипов("СправочникСсылка.Организации");
		Заголовок = НСтр("en='Company:';ru='Организация:'");
		ИмяИзмеренияРегистра = Параметры.ДополнительнаяИнформация;
	ИначеЕсли ТипИзмерения = Перечисления.ТипыИзмеренийФинансовогоОтчета.ИзмерениеРегистра
		И Параметры.ДополнительнаяИнформация = "Подразделение" Тогда
		ВыбранныеЗначения.ТипЗначения = Новый ОписаниеТипов("СправочникСсылка.ПодразделенияОрганизаций");
		Заголовок = НСтр("en='Department:';ru='Подразделение:'");
		ИмяИзмеренияРегистра = Параметры.ДополнительнаяИнформация;
	ИначеЕсли ТипИзмерения = Перечисления.ТипыИзмеренийФинансовогоОтчета.ИзмерениеРегистра
		И Параметры.ДополнительнаяИнформация = "Сценарий" Тогда
		ВыбранныеЗначения.ТипЗначения = Новый ОписаниеТипов("СправочникСсылка.Сценарии");
		Заголовок = НСтр("en='Сценарий планирования:';ru='Сценарий планирования:'");
		ИмяИзмеренияРегистра = Параметры.ДополнительнаяИнформация;
	ИначеЕсли ТипИзмерения = Перечисления.ТипыИзмеренийФинансовогоОтчета.ИзмерениеРегистра
		И Параметры.ДополнительнаяИнформация = "Валюта" Тогда
		ВыбранныеЗначения.ТипЗначения = Новый ОписаниеТипов("СправочникСсылка.Валюты");
		Заголовок = НСтр("en='Currency:';ru='Валюта:'");
		ИмяИзмеренияРегистра = Параметры.ДополнительнаяИнформация;
	ИначеЕсли ТипИзмерения = Перечисления.ТипыИзмеренийФинансовогоОтчета.ИзмерениеРегистра
		И Параметры.ДополнительнаяИнформация = "ЕдиницаИзмерения" Тогда
		ВыбранныеЗначения.ТипЗначения = Новый ОписаниеТипов("СправочникСсылка.ЕдиницыИзмерения");
		Заголовок = НСтр("en='Единица измерения:';ru='Единица измерения:'");
		ИмяИзмеренияРегистра = Параметры.ДополнительнаяИнформация;
	Иначе
		ТекстНСТР = НСтр("en='Unknown dimension type budget report';ru='Неизвестный тип измерения бюджетного отчета'");
		ВызватьИсключение ТекстНСТР;
	КонецЕсли;
	
	Если Параметры.ИспользоватьДляВводаПлана Тогда
		ФиксированноеЗначение = 1;
		Элементы.ВсеЗначения.Доступность = Ложь;
	КонецЕсли;
	
	Если ТипИзмерения = Перечисления.ТипыИзмеренийФинансовогоОтчета.ИзмерениеРегистра Тогда
		Элементы.ГруппаВыборФиксированныхЗначений.ТекущаяСтраница = Элементы.Измерения;
	Иначе
		Элементы.ГруппаВыборФиксированныхЗначений.ТекущаяСтраница = Элементы.ФиксированныеАналитики;
		Если Не Параметры.ИспользоватьДляВводаПлана ИЛИ Параметры.ВКолонки Тогда
			Элементы.ГруппаВидимостьРедактирования.ТекущаяСтраница = Элементы.РедактированиеНедоступно;
		КонецЕсли;
	КонецЕсли;
	
	Владелец = Параметры.Владелец;
	Если Владелец <> Неопределено Тогда
		ВыбранныеЗначения.ТипЗначения = Новый ОписаниеТипов(Владелец.Типы);
		ВладелецЗначений = Владелец.Значение;
	КонецЕсли;
	
	//СобытияФорм.ПриСозданииНаСервере(ЭтотОбъект, Отказ, СтандартнаяОбработка);

КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	ФиксированноеЗначениеПриИзменении(Неопределено);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ФиксированноеЗначениеПриИзменении(Элемент)
	
	УправлениеФормой(ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура ДобавитьПрочиеЗначенияПриИзменении(Элемент)
	
	УправлениеФормой(ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура РазрешитьДобавлениеПриИзменении(Элемент)
	
	Если РазрешитьРедактирование Тогда
		ДобавитьПрочиеЗначения = Истина;
	КонецЕсли;
	
	УправлениеФормой(ЭтотОбъект);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура Выбрать(Команда)
	
	Закрыть(ПолучитьРезультатВыбора());
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ВыполнитьПереопределяемуюКоманду(Команда)
	
	//СобытияФормКлиент.ВыполнитьПереопределяемуюКоманду(ЭтотОбъект, Команда);
	Заглушка = Истина;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура ДобавитьСтрокуРезультата(Результат, СтатьяПоказательТипИзмерения, ЗначениеАналитики = Неопределено, ЭтоАналитикаПрочее = Ложь)
	
	НоваяСтрока = Новый Структура("НаименованиеДляПечати, СтатьяПоказательТипИзмерения, 
									|ЗначениеАналитики, ЭтоАналитикаПрочее, РазрешитьРедактирование");
	НоваяСтрока.НаименованиеДляПечати 			= ?(ЗначениеЗаполнено(ЗначениеАналитики), ЗначениеАналитики, СтатьяПоказательТипИзмерения);
	НоваяСтрока.СтатьяПоказательТипИзмерения 	= СтатьяПоказательТипИзмерения;
	НоваяСтрока.ЗначениеАналитики 				= ЗначениеАналитики;
	НоваяСтрока.ЭтоАналитикаПрочее 				= ЭтоАналитикаПрочее;
	НоваяСтрока.РазрешитьРедактирование			= РазрешитьРедактирование;
	
	Результат.Добавить(НоваяСтрока);
	
КонецПроцедуры

&НаСервере
Функция ПолучитьРезультатВыбора()
	
	Результат = Новый Массив;
	
	Если ТипИзмерения = Перечисления.ТипыИзмеренийФинансовогоОтчета.ИзмерениеРегистра Тогда
		Если Не ФиксированноеЗначение Тогда
			ДобавитьСтрокуРезультата(Результат, ИмяИзмеренияРегистра, СтрЗаменить(Заголовок, ":", ""));
		Иначе
			Для Каждого Элемент из ВыбранныеЗначения Цикл
				Если Не ЗначениеЗаполнено(Элемент.Значение) Тогда
					Продолжить;
				КонецЕсли;
				ДобавитьСтрокуРезультата(Результат, Элемент.Значение);
			КонецЦикла;
		КонецЕсли;
	ИначеЕсли ТипИзмерения = Перечисления.ТипыИзмеренийФинансовогоОтчета.Аналитика Тогда
		Если Не ФиксированноеЗначение Тогда
			ДобавитьСтрокуРезультата(Результат, ВидАналитики);
		Иначе
			Для Каждого Элемент из ВыбранныеЗначения Цикл
				Если Не ЗначениеЗаполнено(Элемент.Значение) Тогда
					Продолжить;
				КонецЕсли;
				ДобавитьСтрокуРезультата(Результат, ВидАналитики, Элемент.Значение);
			КонецЦикла;
			Если ДобавитьПрочиеЗначения Тогда
				ДобавитьСтрокуРезультата(Результат, ВидАналитики, , Истина);
			КонецЕсли;
		КонецЕсли;
	Иначе
		ТекстНСТР = НСтр("en='Unknown dimension type budget report';ru='Неизвестный тип измерения бюджетного отчета'");
		ВызватьИсключение ТекстНСТР;
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции

&НаСервереБезКонтекста
Функция ПолучитьСписокВыбораТипов(ТипЗначения)
	
	Типы = Новый СписокЗначений;
	Для Каждого Тип из ТипЗначения.Типы() Цикл
		Типы.Добавить(Тип, Метаданные.НайтиПоТипу(Тип).Синоним);
	КонецЦикла;
	
	Возврат Типы;

КонецФункции

&НаСервереБезКонтекста
Функция ПолучитьИмяФормы(ТипПодбора)
	
	ПолноеИмя = Метаданные.НайтиПоТипу(ТипПодбора).ПолноеИмя();
	Возврат ПолноеИмя + ".ФормаВыбора";
	
КонецФункции

&НаСервереБезКонтекста
Функция ПолучитьПараметрыФормы(ВладелецЗначений, ТипПодбора)
	
	ПереопределенныйВладелец = ФинансоваяОтчетностьПовтИсп.СоответствиеОтборовПоВладельцу()[ТипПодбора];
	ПараметрыФормы = Новый Структура(
			"МножественныйВыбор, РежимВыбора, ЗакрыватьПриВыборе", 
			Истина, Истина, Ложь);
	
	Если ЗначениеЗаполнено(ВладелецЗначений) Тогда
		Если ПереопределенныйВладелец <> Неопределено Тогда
			ПараметрыВладельца = ПереопределенныйВладелец.Найти(ТипЗнч(ВладелецЗначений), "Тип");
			Отбор = Новый Структура(ПараметрыВладельца.Реквизит, ВладелецЗначений);
		Иначе
			Отбор = Новый Структура("Владелец", ВладелецЗначений);
		КонецЕсли;
		ПараметрыФормы.Вставить("Отбор", Отбор);
	КонецЕсли;
	
	Возврат ПараметрыФормы;
	
КонецФункции

&НаКлиенте
Процедура Подбор(Команда)
	
	Типы = ПолучитьСписокВыбораТипов(ВыбранныеЗначения.ТипЗначения);
	Если Типы.Количество() = 0 Тогда
		Возврат;
	ИначеЕсли Типы.Количество() = 1 Тогда
		ТипПодбора = Типы[0].Значение;
	Иначе
		РезультатВыбора = Типы.ВыбратьЭлемент(НСтр("en='Select value type';ru='Выберите тип значения'"));
		Если РезультатВыбора = Неопределено Тогда
			Возврат;
		КонецЕсли;
		ТипПодбора = РезультатВыбора.Значение;
	КонецЕсли;
	
	ПараметрыФормы = ПолучитьПараметрыФормы(ВладелецЗначений, ТипПодбора);
	
	ОткрытьФорму(ПолучитьИмяФормы(ТипПодбора), ПараметрыФормы, Элементы.ВыбранныеЗначенияИзмерения, , , , , РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
	
КонецПроцедуры

&НаКлиентеНаСервереБезконтекста
Процедура УправлениеФормой(Форма)
	
	Форма.Элементы.ВыбранныеЗначенияАналитика.Доступность = Форма.ФиксированноеЗначение;
	Форма.Элементы.ВыбранныеЗначенияИзмерения.Доступность = Форма.ФиксированноеЗначение;
	ДобавитьПрочиеЗначения = Форма.ФиксированноеЗначение И НЕ Форма.РазрешитьРедактирование;
	Форма.Элементы.РазрешитьРедактирование.Доступность = Форма.ФиксированноеЗначение;
	Форма.Элементы.ДобавитьПрочиеЗначения.Доступность = ДобавитьПрочиеЗначения;
	
КонецПроцедуры

&НаКлиенте
Процедура ВыборДополнительныхПолей(Команда)

	ОткрытьФорму("Справочник.ЭлементыФинансовыхОтчетов.Форма.НастройкаДополнительныхПолей",,,,,,,РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
	
КонецПроцедуры

#КонецОбласти

