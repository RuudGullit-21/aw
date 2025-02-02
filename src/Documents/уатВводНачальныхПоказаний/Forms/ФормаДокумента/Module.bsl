
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	уатЗащищенныеФункцииСервер.уатДокументФормаЭлементаПриСозданииНаСервере(Отказ, СтандартнаяОбработка, Объект, ЭтотОбъект, ДопПараметрыОткрытие);
	Если Отказ тогда
		Возврат;
	КонецЕсли;
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКоманды.ПриСозданииНаСервере(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
	// СтандартныеПодсистемы.ВерсионированиеОбъектов
	ВерсионированиеОбъектов.ПриСозданииНаСервере(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ВерсионированиеОбъектов
	
	уатОбщегоНазначенияСервер.НастроитьПолеПодразделение(Элементы.Подразделение, "Объект.Организация");
	
КонецПроцедуры

&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)
	
	// СтандартныеПодсистемы.УправлениеДоступом
	Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.УправлениеДоступом") Тогда
		МодульУправлениеДоступом = ОбщегоНазначения.ОбщийМодуль("УправлениеДоступом");
		МодульУправлениеДоступом.ПриЧтенииНаСервере(ЭтотОбъект, ТекущийОбъект);
	КонецЕсли;
	// Конец СтандартныеПодсистемы.УправлениеДоступом
	
	// СтандартныеПодсистемы.ДатыЗапретаИзменения
	ДатыЗапретаИзменения.ОбъектПриЧтенииНаСервере(ЭтотОбъект, ТекущийОбъект);
	// Конец СтандартныеПодсистемы.ДатыЗапретаИзменения
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиентСервер.ОбновитьКоманды(ЭтотОбъект, Объект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	уатЗащищенныеФункцииКлиент.уатДокументФормаЭлементаПриОткрытии(Отказ, ЭтотОбъект, ДопПараметрыОткрытие);
	Если Отказ тогда
		Возврат;
	КонецЕсли;
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиент.НачатьОбновлениеКоманд(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
КонецПроцедуры

&НаКлиенте
Процедура ПослеЗаписи(ПараметрыЗаписи)
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиент.ПослеЗаписи(ЭтотОбъект, Объект, ПараметрыЗаписи);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
КонецПроцедуры

&НаСервере
Процедура ПослеЗаписиНаСервере(ТекущийОбъект, ПараметрыЗаписи)
	// СтандартныеПодсистемы.УправлениеДоступом
	УправлениеДоступом.ПослеЗаписиНаСервере(ЭтотОбъект, ТекущийОбъект, ПараметрыЗаписи);
	// Конец СтандартныеПодсистемы.УправлениеДоступом
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура КомментарийНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	ОбщегоНазначенияКлиент.ПоказатьФормуРедактированияКомментария(Элемент.ТекстРедактирования, ЭтотОбъект, "Объект.Комментарий");
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыСпидометр

&НаКлиенте
Процедура СпидометрПриАктивизацииЯчейки(Элемент)
	
	Элемент.ТекущийЭлемент.ТолькоПросмотр = Ложь;
	
	ТекСтрока = Элементы.Спидометр.ТекущиеДанные;
	Если Не ТекСтрока = Неопределено И ЗначениеЗаполнено(ТекСтрока.ТС) Тогда 
		Если НаТСУстановленСпидометр(ТекСтрока.ТС) Тогда 
			// блок моточас
			Если Элемент.ТекущийЭлемент.Имя = "СпидометрПоказанияСчетчикаМЧ" Тогда 
				Элемент.ТекущийЭлемент.ТолькоПросмотр = Истина;
			КонецЕсли;
		Иначе 
			// блок спидом
			Если Элемент.ТекущийЭлемент.Имя = "СпидометрПоказанияСпидометра" Тогда 
				Элемент.ТекущийЭлемент.ТолькоПросмотр = Истина;
			КонецЕсли;
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура СпидометрТСНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	СтруктураОтбор = Новый Структура("Организация", Объект.Организация);
	уатИнтерфейсВводаТС.РеквизитТСНачалоВыбора(Элемент, Элементы.Спидометр.ТекущиеДанные.ТС, ДанныеВыбора, СтандартнаяОбработка, СтруктураОтбор);
КонецПроцедуры

&НаКлиенте
Процедура СпидометрТСАвтоПодбор(Элемент, Текст, ДанныеВыбора, ПараметрыПолученияДанных, Ожидание, СтандартнаяОбработка)
	СтруктураОтбор = Новый Структура("Организация", Объект.Организация);
	уатИнтерфейсВводаТС.РеквизитТСАвтоПодбор(Элемент, Текст, ДанныеВыбора, ПараметрыПолученияДанных, Ожидание, СтандартнаяОбработка, СтруктураОтбор);
КонецПроцедуры

&НаКлиенте
Процедура СпидометрТСОкончаниеВводаТекста(Элемент, Текст, ДанныеВыбора, ПараметрыПолученияДанных, СтандартнаяОбработка)
	СтруктураОтбор = Новый Структура("Организация", Объект.Организация);
	уатИнтерфейсВводаТС.РеквизитТСОкончаниеВводаТекста(Элемент, Текст, ДанныеВыбора, ПараметрыПолученияДанных, СтандартнаяОбработка, СтруктураОтбор);
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормы_ИсторияПрохожденияТО

&НаКлиенте
Процедура ИсторияПрохожденияТОТСПриИзменении(Элемент)
	
	ТекущиеДанные = Элементы.ИсторияПрохожденияТО.ТекущиеДанные;
	Если ТекущиеДанные = Неопределено Тогда 
		Возврат;
	КонецЕсли;
	
	ТекущиеДанные.ДатаТО              = Неопределено;
	ТекущиеДанные.ВидОбслуживания     = Неопределено;
	ТекущиеДанные.ПараметрВыработкиТО = Неопределено;
	ТекущиеДанные.ВыработкаПриТО      = Неопределено;
	
КонецПроцедуры

&НаКлиенте
Процедура ИсторияПрохожденияТОТСНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	СтруктураОтбор = Новый Структура("Организация", Объект.Организация);
	уатИнтерфейсВводаТС.РеквизитТСНачалоВыбора(Элемент, Элементы.ИсторияПрохожденияТО.ТекущиеДанные.ТС, ДанныеВыбора, СтандартнаяОбработка, СтруктураОтбор);
	
КонецПроцедуры

&НаКлиенте
Процедура ИсторияПрохожденияТОТСАвтоПодбор(Элемент, Текст, ДанныеВыбора, ПараметрыПолученияДанных, Ожидание, СтандартнаяОбработка)
	
	СтруктураОтбор = Новый Структура("Организация", Объект.Организация);
	уатИнтерфейсВводаТС.РеквизитТСАвтоПодбор(Элемент, Текст, ДанныеВыбора, ПараметрыПолученияДанных, Ожидание, СтандартнаяОбработка, СтруктураОтбор);
	
КонецПроцедуры

&НаКлиенте
Процедура ИсторияПрохожденияТОТСОкончаниеВводаТекста(Элемент, Текст, ДанныеВыбора, ПараметрыПолученияДанных, СтандартнаяОбработка)
	
	СтруктураОтбор = Новый Структура("Организация", Объект.Организация);
	уатИнтерфейсВводаТС.РеквизитТСОкончаниеВводаТекста(Элемент, Текст, ДанныеВыбора, ПараметрыПолученияДанных, СтандартнаяОбработка, СтруктураОтбор);
	
КонецПроцедуры

&НаКлиенте
Процедура ИсторияПрохожденияТОВидОбслуживанияПриИзменении(Элемент)
	
	ТекущиеДанные = Элементы.ИсторияПрохожденияТО.ТекущиеДанные;
	Если ТекущиеДанные = Неопределено Тогда 
		Возврат;
	КонецЕсли;
	
	ТекущиеДанные.ПараметрВыработкиТО = ПолучитьПараметрВыработкиОбслуживания(ТекущиеДанные.ТС, ТекущиеДанные.ВидОбслуживания);
	ТекущиеДанные.ВыработкаПриТО = Неопределено;
	
КонецПроцедуры

&НаКлиенте
Процедура ИсторияПрохожденияТОВидОбслуживанияНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	ТекущиеДанные = Элементы.ИсторияПрохожденияТО.ТекущиеДанные;
	Если ТекущиеДанные = Неопределено Тогда 
		Возврат;
	КонецЕсли;
	
	ОткрытьФорму(
		"Справочник.уатВидыОбслуживанияТС.ФормаВыбора", 
		Новый Структура("Отбор, ТекущаяСтрока", 
			Новый Структура("Ссылка", ПолучитьСписокВидовОбслуживания(ТекущиеДанные.ТС)), 
			ТекущиеДанные.ВидОбслуживания
		),
		Элемент
	);
	
КонецПроцедуры

&НаКлиенте
Процедура ИсторияПрохожденияТОВидОбслуживанияАвтоПодбор(Элемент, Текст, ДанныеВыбора, ПараметрыПолученияДанных, Ожидание, СтандартнаяОбработка)
	
	ТекущиеДанные = Элементы.ИсторияПрохожденияТО.ТекущиеДанные;
	Если ТекущиеДанные = Неопределено Тогда 
		Возврат;
	КонецЕсли;
	
	ДанныеВыбора = ПолучитьСписокВыбораВидовОбслуживания(Текст, СтандартнаяОбработка, ТекущиеДанные.ТС);
	
КонецПроцедуры

&НаКлиенте
Процедура ИсторияПрохожденияТОВидОбслуживанияОкончаниеВводаТекста(Элемент, Текст, ДанныеВыбора, ПараметрыПолученияДанных, СтандартнаяОбработка)
	
	Если Текст = "" Тогда 
		Возврат;
	КонецЕсли;
	
	ТекущиеДанные = Элементы.ИсторияПрохожденияТО.ТекущиеДанные;
	Если ТекущиеДанные = Неопределено Тогда 
		Возврат;
	КонецЕсли;
	
	ДанныеВыбора = ПолучитьСписокВыбораВидовОбслуживания(Текст, СтандартнаяОбработка, ТекущиеДанные.ТС);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

// СтандартныеПодсистемы.ПодключаемыеКоманды
&НаКлиенте
Процедура Подключаемый_ВыполнитьКоманду(Команда)
	ПодключаемыеКомандыКлиент.НачатьВыполнениеКоманды(ЭтотОбъект, Команда, Объект);
КонецПроцедуры
// Конец СтандартныеПодсистемы.ПодключаемыеКоманды

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// СтандартныеПодсистемы.ПодключаемыеКоманды
&НаКлиенте
Процедура Подключаемый_ПродолжитьВыполнениеКомандыНаСервере(ПараметрыВыполнения, ДополнительныеПараметры) Экспорт
    ВыполнитьКомандуНаСервере(ПараметрыВыполнения);
КонецПроцедуры

&НаСервере
Процедура ВыполнитьКомандуНаСервере(ПараметрыВыполнения)
    ПодключаемыеКоманды.ВыполнитьКоманду(ЭтотОбъект, ПараметрыВыполнения, Объект);
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ОбновитьКоманды()
    ПодключаемыеКомандыКлиентСервер.ОбновитьКоманды(ЭтотОбъект, Объект);
КонецПроцедуры
// Конец СтандартныеПодсистемы.ПодключаемыеКоманды

&НаСервере
Функция НаТСУстановленСпидометр(ТС)
	
	Если ТС.Модель.НаличиеСпидометра = Истина Тогда 
		Возврат Истина;
	Иначе 
		Возврат Ложь;
	КонецЕсли;
	
КонецФункции // НаТСУстановленСпидометр()

&НаСервереБезКонтекста
Функция ПолучитьПараметрВыработкиОбслуживания(ТС, ВидОбслуживания)
	
	Запрос = Новый Запрос();
	Запрос.УстановитьПараметр("ТС", ТС);
	Запрос.УстановитьПараметр("ВидОбслуживания", ВидОбслуживания);
	
	Запрос.Текст =
	"ВЫБРАТЬ РАЗРЕШЕННЫЕ РАЗЛИЧНЫЕ ПЕРВЫЕ 1
	|	уатМоделиТСНормативыОбслуживания.ПараметрВыработки КАК ПараметрВыработки
	|ИЗ
	|	Справочник.уатТС КАК уатТС
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Справочник.уатМоделиТС.НормативыОбслуживания КАК уатМоделиТСНормативыОбслуживания
	|		ПО (уатТС.Ссылка = &ТС)
	|			И (уатМоделиТСНормативыОбслуживания.ВидОбслуживания = &ВидОбслуживания)
	|			И уатТС.Модель = уатМоделиТСНормативыОбслуживания.Ссылка";
	
	Выборка = Запрос.Выполнить().Выбрать();
	Если Выборка.Следующий() Тогда 
		Возврат Выборка.ПараметрВыработки;
	Иначе 
		Возврат Справочники.уатПараметрыВыработки.ПустаяСсылка();
	КонецЕсли;
	
КонецФункции // ПолучитьПараметрВыработкиОбслуживания()

&НаСервереБезКонтекста
Функция ПолучитьСписокВидовОбслуживания(ТС)
	
	СписокВидовОбслуживания = Новый Массив();
	
	Запрос = Новый Запрос();
	Запрос.УстановитьПараметр("ТС", ТС);
	
	Запрос.Текст =
	"ВЫБРАТЬ РАЗРЕШЕННЫЕ РАЗЛИЧНЫЕ
	|	уатМоделиТСНормативыОбслуживания.ВидОбслуживания КАК ВидОбслуживания
	|ИЗ
	|	Справочник.уатТС КАК уатТС
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Справочник.уатМоделиТС.НормативыОбслуживания КАК уатМоделиТСНормативыОбслуживания
	|		ПО (уатТС.Ссылка = &ТС)
	|			И уатТС.Модель = уатМоделиТСНормативыОбслуживания.Ссылка";
	
	Выборка = Запрос.Выполнить().Выбрать();
	Пока Выборка.Следующий() Цикл 
		СписокВидовОбслуживания.Добавить(Выборка.ВидОбслуживания);
	КонецЦикла;
	
	Возврат СписокВидовОбслуживания;
	
КонецФункции // ПолучитьСписокВидовОбслуживания()

&НаСервереБезКонтекста
Функция ПолучитьСписокВыбораВидовОбслуживания(Текст, СтандартнаяОбработка, ТС)
	
	СтандартнаяОбработка = Ложь;
	
	СтрокаПодбора = СтрЗаменить(Текст, "~", "~~");
	СтрокаПодбора = СтрЗаменить(СтрокаПодбора, "%", "~%");
	СтрокаПодбора = СтрЗаменить(СтрокаПодбора, "_", "~_");
	СтрокаПодбора = СтрЗаменить(СтрокаПодбора, "[", "~[");
	СтрокаПодбора = СтрЗаменить(СтрокаПодбора, "-", "~-");
	СтрокаПодбора = "%" + СокрЛП(СтрокаПодбора) + "%";
	 
	Запрос = Новый Запрос();
	Запрос.УстановитьПараметр("ТС", ТС);
	Запрос.УстановитьПараметр("СтрокаПодбора", СтрокаПодбора);
	
	Запрос.Текст =
	"ВЫБРАТЬ РАЗРЕШЕННЫЕ РАЗЛИЧНЫЕ ПЕРВЫЕ 51
	|	уатМоделиТСНормативыОбслуживания.ВидОбслуживания КАК Ссылка,
	|	уатМоделиТСНормативыОбслуживания.ВидОбслуживания.Наименование КАК Наименование
	|ИЗ
	|	Справочник.уатТС КАК уатТС
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Справочник.уатМоделиТС.НормативыОбслуживания КАК уатМоделиТСНормативыОбслуживания
	|		ПО (уатТС.Ссылка = &ТС)
	|			И уатТС.Модель = уатМоделиТСНормативыОбслуживания.Ссылка
	|ГДЕ
	|	уатМоделиТСНормативыОбслуживания.ВидОбслуживания.Наименование ПОДОБНО &СтрокаПодбора СПЕЦСИМВОЛ ""~""
	|
	|УПОРЯДОЧИТЬ ПО
	|	Наименование";
	
	Выборка = Запрос.Выполнить().Выбрать();
	 
	ДанныеВыбора = Новый СписокЗначений();
	
	Пока Выборка.Следующий() Цикл 
		врПозицияОтсечения = СтрДлина(Текст);
		тПредставление = Новый ФорматированнаяСтрока(
			Новый ФорматированнаяСтрока(Лев(Выборка.Наименование, врПозицияОтсечения),, ЦветаСтиля.уатЦветТекстаПриАвтоподборе), 
			Новый ФорматированнаяСтрока(Прав(Выборка.Наименование, СтрДлина(Выборка.Наименование)-врПозицияОтсечения)));
		ДанныеВыбора.Добавить(Выборка.Ссылка, тПредставление);
	КонецЦикла;
	
	Возврат ДанныеВыбора;
	  
КонецФункции // ПолучитьСписокВыбораВидовОбслуживания()

#КонецОбласти
