
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	уатЗащищенныеФункцииСервер.уатДокументФормаЭлементаПриСозданииНаСервере(Отказ, СтандартнаяОбработка, Объект, ЭтотОбъект, ДопПараметрыОткрытие);
	Если Отказ тогда
		Возврат;
	КонецЕсли;
	
	// СтандартныеПодсистемы.ВерсионированиеОбъектов
	ВерсионированиеОбъектов.ПриСозданииНаСервере(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ВерсионированиеОбъектов
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКоманды.ПриСозданииНаСервере(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
	уатОбщегоНазначенияСервер.НастроитьПолеПодразделение(Элементы.Подразделение, "Объект.Организация");
	уатОбщегоНазначенияСервер.НастроитьПолеПодразделение(Элементы.НачисленияПодразделениеОрганизации, "Объект.Организация");
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	// уатУправлениеАвтотранспортом.МодификацияКонфигурации
	уатМодификацияКонфигурацииКлиентПереопределяемый.ПриОткрытии(ЭтотОбъект, Отказ);
	// Конец уатУправлениеАвтотранспортом.МодификацияКонфигурации
	
	уатЗащищенныеФункцииКлиент.уатДокументФормаЭлементаПриОткрытии(Отказ, ЭтотОбъект, ДопПараметрыОткрытие);
	Если Отказ тогда
		Возврат;
	КонецЕсли;
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиент.НачатьОбновлениеКоманд(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
	Если Объект.Ссылка.Пустая() Тогда
		Объект.ПериодРегистрации = ТекущаяДата();
		ОпределитьДатыПериодаНачисления();
	КонецЕсли;
	ОбновитьМесяцПредставление();
	
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

&НаСервере
Процедура ПослеЗаписиНаСервере(ТекущийОбъект, ПараметрыЗаписи)
	// СтандартныеПодсистемы.УправлениеДоступом
	УправлениеДоступом.ПослеЗаписиНаСервере(ЭтотОбъект, ТекущийОбъект, ПараметрыЗаписи);
	// Конец СтандартныеПодсистемы.УправлениеДоступом
КонецПроцедуры

&НаКлиенте
Процедура ПослеЗаписи(ПараметрыЗаписи)
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиент.ПослеЗаписи(ЭтотОбъект, Объект, ПараметрыЗаписи);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ПериодРегистрацииПриИзменении(Элемент)
	ОпределитьДатыПериодаНачисления();
КонецПроцедуры

&НаКлиенте
Процедура ПериодРегистрацииОчистка(Элемент, СтандартнаяОбработка)
	СтандартнаяОбработка = Ложь;
КонецПроцедуры

&НаКлиенте
Процедура ПериодРегистрацииРегулирование(Элемент, Направление, СтандартнаяОбработка)
	Объект.ПериодРегистрации = ДобавитьМесяц(Объект.ПериодРегистрации, Направление);
	ОпределитьДатыПериодаНачисления();
	ОбновитьМесяцПредставление();
КонецПроцедуры

&НаКлиенте
Процедура ПериодРегистрацииНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	СтандартнаяОбработка = Ложь;
	
	стандПериод = Новый СтандартныйПериод;
	стандПериод.Вариант = ВариантСтандартногоПериода.Месяц;
	стандПериод.ДатаНачала = НачалоМесяца(Объект.ПериодНачисленияДатаНачала);
	стандПериод.ДатаОкончания = КонецМесяца(Объект.ПериодНачисленияДатаНачала);
	
	ДиалогВыбораПериода = Новый ДиалогРедактированияСтандартногоПериода();
	ДиалогВыбораПериода.Период = стандПериод;
	ДиалогВыбораПериода.Показать(Новый ОписаниеОповещения("ВыборПериодаНачисленияЗавершение", ЭтотОбъект));
КонецПроцедуры

&НаКлиенте
Процедура КомментарийНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	ОбщегоНазначенияКлиент.ПоказатьФормуРедактированияКомментария(Элемент.ТекстРедактирования, ЭтотОбъект, "Объект.Комментарий");
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыНачисления

&НаКлиенте
Процедура НачисленияСотрудникНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	уатЗащищенныеФункцииКлиент.ДиалогВыбораСотрудника(Элемент, Элементы.Начисления.ТекущиеДанные.Сотрудник,
	 Новый Структура("Организация, Подразделение", Объект.Организация, Объект.Подразделение), СтандартнаяОбработка);
КонецПроцедуры

&НаКлиенте
Процедура НачисленияСотрудникОткрытие(Элемент, СтандартнаяОбработка)
	уатЗащищенныеФункцииКлиент.ОткрытьФормуСотрудника(Элементы.Начисления.ТекущиеДанные.Сотрудник, СтандартнаяОбработка);
КонецПроцедуры

&НаКлиенте
Процедура НачисленияСотрудникАвтоПодбор(Элемент, Текст, ДанныеВыбора, ПараметрыПолученияДанных, Ожидание, СтандартнаяОбработка)
	СтруктураПараметров = Новый Структура("Организация, ДатаСреза", Объект.Организация, Объект.Дата);
	уатИнтерфейсВводаСотрудников.СотрудникАвтоПодборТекста(Элемент, Текст, ДанныеВыбора, СтандартнаяОбработка, СтруктураПараметров);
КонецПроцедуры

&НаКлиенте
Процедура НачисленияСотрудникОкончаниеВводаТекста(Элемент, Текст, ДанныеВыбора, ПараметрыПолученияДанных, СтандартнаяОбработка)
	СтруктураПараметров = Новый Структура("Организация, ДатаСреза", Объект.Организация, Объект.Дата);
	уатИнтерфейсВводаСотрудников.СотрудникОкончаниеВводаТекста(Элемент, Текст, ДанныеВыбора, СтандартнаяОбработка, СтруктураПараметров);
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

// СтандартныеПодсистемы.ПодключаемыеКоманды
&НаКлиенте
Процедура Подключаемый_ВыполнитьКоманду(Команда)
	ПодключаемыеКомандыКлиент.НачатьВыполнениеКоманды(ЭтотОбъект, Команда, Объект);
КонецПроцедуры
// Конец СтандартныеПодсистемы.ПодключаемыеКоманды

&НаКлиенте
Процедура ЗаполнитьПоОсновнымНачислениям(Команда)
	Если Объект.Начисления.Количество() > 0 Тогда
		ТекстНСТР = НСтр("en='Table will be cleared before filling! Continue?';ru='Перед заполнением таблица будет очищена! Продолжить?'");
		ПоказатьВопрос(Новый ОписаниеОповещения("ЗаполнитьПоОсновнымНачислениямЗавершение", ЭтотОбъект),
			ТекстНСТР, РежимДиалогаВопрос.ДаНет,, КодВозвратаДиалога.Нет);
        Возврат;  
	КонецЕсли;  
	
	ЗаполнитьПоОсновнымНачислениямФрагмент();
КонецПроцедуры

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

&НаКлиенте
Процедура ОпределитьДатыПериодаНачисления()
	Объект.ПериодНачисленияДатаНачала = НачалоМесяца(Объект.ПериодРегистрации);
	Объект.ПериодНачисленияДатаОкончания = КонецМесяца(Объект.ПериодРегистрации);
КонецПроцедуры

// Функция возвращает дату в формате месяц прописью + год
// Например, "Январь 2008"
&НаКлиенте
Функция ДатаКакМесяцПредставление(ДатаДата)
	Возврат Формат(ДатаДата, "ДФ='ММММ гггг'");
КонецФункции // ДатаКакМесяцПредставление()

&НаКлиенте
Функция ОбновитьМесяцПредставление()
	МесяцСтрока = ДатаКакМесяцПредставление(Объект.ПериодРегистрации);
КонецФункции

&НаСервере
Процедура ЗаполнитьОсновнымиНачислениями()
	
	тблРабочееВремяПоПодразделениям = уатОбщегоНазначения.РабочееВремяСотрудниковПоПодразделениям(
		Объект.ПериодНачисленияДатаНачала, КонецДня(Объект.ПериодНачисленияДатаОкончания),, Объект.Организация);
	
	Запрос = Новый Запрос;
    Запрос.Текст =
	"ВЫБРАТЬ
	|	тблРабочееВремяПоПодразделениям.Сотрудник КАК Сотрудник,
	|	тблРабочееВремяПоПодразделениям.Подразделение КАК Подразделение,
	|	тблРабочееВремяПоПодразделениям.ВидИспользованияРабочегоВремени КАК ВидИспользованияРабочегоВремени,
	|	тблРабочееВремяПоПодразделениям.ДатаРаботы КАК ДатаРаботы,
	|	тблРабочееВремяПоПодразделениям.ВремяОборот КАК ВремяОборот
	|ПОМЕСТИТЬ ВТ_РабочееВремяПоПодразделениям
	|ИЗ
	|	&тблРабочееВремяПоПодразделениям КАК тблРабочееВремяПоПодразделениям
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	уатРабочееВремяСотрудниковОбороты.Сотрудник КАК Сотрудник,
	|	уатРабочееВремяСотрудниковОбороты.Подразделение КАК Подразделение,
	|	КОЛИЧЕСТВО(РАЗЛИЧНЫЕ уатРабочееВремяСотрудниковОбороты.ДатаРаботы) КАК ДнейОборот,
	|	СУММА(уатРабочееВремяСотрудниковОбороты.ВремяОборот) КАК ВремяОборот
	|ПОМЕСТИТЬ ВТ_Работа
	|ИЗ
	|	ВТ_РабочееВремяПоПодразделениям КАК уатРабочееВремяСотрудниковОбороты
	|ГДЕ
	|	(уатРабочееВремяСотрудниковОбороты.ВидИспользованияРабочегоВремени = ЗНАЧЕНИЕ(Справочник.уатВидыИспользованияРабочегоВремени.Явка)
	|			ИЛИ уатРабочееВремяСотрудниковОбороты.ВидИспользованияРабочегоВремени = ЗНАЧЕНИЕ(Справочник.уатВидыИспользованияРабочегоВремени.Праздники))
	|
	|СГРУППИРОВАТЬ ПО
	|	уатРабочееВремяСотрудниковОбороты.Сотрудник,
	|	уатРабочееВремяСотрудниковОбороты.Подразделение
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	уатРабочееВремяСотрудниковОбороты.Сотрудник КАК Сотрудник,
	|	уатРабочееВремяСотрудниковОбороты.Подразделение КАК Подразделение,
	|	КОЛИЧЕСТВО(РАЗЛИЧНЫЕ уатРабочееВремяСотрудниковОбороты.ДатаРаботы) КАК ДнейОборот,
	|	СУММА(уатРабочееВремяСотрудниковОбороты.ВремяОборот) КАК ВремяОборот
	|ПОМЕСТИТЬ ВТ_Ремонты
	|ИЗ
	|	ВТ_РабочееВремяПоПодразделениям КАК уатРабочееВремяСотрудниковОбороты
	|ГДЕ
	|	уатРабочееВремяСотрудниковОбороты.ВидИспользованияРабочегоВремени = ЗНАЧЕНИЕ(Справочник.уатВидыИспользованияРабочегоВремени.Ремонт)
	|
	|СГРУППИРОВАТЬ ПО
	|	уатРабочееВремяСотрудниковОбороты.Сотрудник,
	|	уатРабочееВремяСотрудниковОбороты.Подразделение
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	уатОсновныеНачисления.Сотрудник КАК Сотрудник,
	|	уатОсновныеНачисления.ВидРасчета КАК ВидРасчета,
	|	СУММА(уатОсновныеНачисления.Результат) КАК Результат,
	|	уатОсновныеНачисления.Подразделение КАК Подразделение
	|ПОМЕСТИТЬ ВТ_Начисления
	|ИЗ
	|	РегистрРасчета.уатОсновныеНачисления КАК уатОсновныеНачисления
	|ГДЕ
	|	уатОсновныеНачисления.Организация = &Организация
	|	И уатОсновныеНачисления.ПериодРегистрации МЕЖДУ &ДатаНач И &ДатаКон
	|
	|СГРУППИРОВАТЬ ПО
	|	уатОсновныеНачисления.Сотрудник,
	|	уатОсновныеНачисления.ВидРасчета,
	|	уатОсновныеНачисления.Подразделение
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ВЫБОР
	|		КОГДА ВТ_Ремонты.Сотрудник ЕСТЬ NULL
	|			ТОГДА ВЫБОР
	|					КОГДА ВТ_Работа.Сотрудник ЕСТЬ NULL
	|						ТОГДА ВТ_Начисления.Сотрудник
	|					ИНАЧЕ ВТ_Работа.Сотрудник
	|				КОНЕЦ
	|		ИНАЧЕ ВТ_Ремонты.Сотрудник
	|	КОНЕЦ КАК Сотрудник,
	|	ВЫБОР
	|		КОГДА ВТ_Ремонты.Подразделение ЕСТЬ NULL
	|			ТОГДА ВЫБОР
	|					КОГДА ВТ_Работа.Подразделение ЕСТЬ NULL
	|						ТОГДА ВТ_Начисления.Подразделение
	|					ИНАЧЕ ВТ_Работа.Подразделение
	|				КОНЕЦ
	|		ИНАЧЕ ВТ_Ремонты.Подразделение
	|	КОНЕЦ КАК Подразделение,
	|	ВТ_Работа.ДнейОборот КАК Дней,
	|	ВТ_Работа.ВремяОборот КАК Время,
	|	ВТ_Ремонты.ДнейОборот КАК ДнейВРемонте,
	|	ВТ_Ремонты.ВремяОборот КАК ВремяВРемонте,
	|	ВТ_Начисления.ВидРасчета КАК ВидРасчета,
	|	ВТ_Начисления.Результат КАК Результат
	|ПОМЕСТИТЬ ВТ_ОбщаяТаблица
	|ИЗ
	|	ВТ_Работа КАК ВТ_Работа
	|		ПОЛНОЕ СОЕДИНЕНИЕ ВТ_Начисления КАК ВТ_Начисления
	|			ПОЛНОЕ СОЕДИНЕНИЕ ВТ_Ремонты КАК ВТ_Ремонты
	|			ПО (ВТ_Ремонты.Сотрудник = ВТ_Начисления.Сотрудник)
	|				И (ВТ_Ремонты.Подразделение = ВТ_Начисления.Подразделение)
	|		ПО ВТ_Работа.Сотрудник = ВТ_Начисления.Сотрудник
	|			И ВТ_Работа.Подразделение = ВТ_Начисления.Подразделение
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ РАЗРЕШЕННЫЕ РАЗЛИЧНЫЕ
	|	ВТ_ОбщаяТаблица.ВидРасчета КАК ВидРасчета,
	|	ВТ_ОбщаяТаблица.Результат КАК Результат,
	|	ВТ_ОбщаяТаблица.Сотрудник КАК Сотрудник,
	|	ВТ_ОбщаяТаблица.Дней КАК Дней,
	|	ЕСТЬNULL(ВТ_ОбщаяТаблица.Время, 0) КАК Время,
	|	ВЫБОР
	|		КОГДА ВТ_ОбщаяТаблица.ВидРасчета = ЗНАЧЕНИЕ(ПланВидовРасчета.уатОсновныеНачисления.ОплатаПоЧасовомуТарифу)
	|				ИЛИ ВТ_ОбщаяТаблица.ВидРасчета ЕСТЬ NULL
	|			ТОГДА 1
	|		ИНАЧЕ 0
	|	КОНЕЦ КАК ЕстьЧасы,
	|	ВТ_ОбщаяТаблица.ДнейВРемонте КАК ДнейВРемонте,
	|	ВТ_ОбщаяТаблица.ВремяВРемонте КАК ВремяВРемонте,
	|	ВТ_ОбщаяТаблица.Подразделение КАК ПодразделениеОрганизации
	|ИЗ
	|	ВТ_ОбщаяТаблица КАК ВТ_ОбщаяТаблица
	|ГДЕ
	|	(&Подразделение = ЗНАЧЕНИЕ(Справочник.ПодразделенияОрганизаций.ПустаяСсылка)
	|			ИЛИ ВТ_ОбщаяТаблица.Подразделение = &Подразделение)
	|ИТОГИ
	|	СУММА(Результат),
	|	МАКСИМУМ(Дней),
	|	МАКСИМУМ(Время),
	|	МАКСИМУМ(ЕстьЧасы),
	|	МАКСИМУМ(ПодразделениеОрганизации)
	|ПО
	|	Сотрудник";
	Запрос.УстановитьПараметр("Подразделение", Объект.Подразделение);
    Запрос.УстановитьПараметр("ДатаНач",       Объект.ПериодНачисленияДатаНачала);
    Запрос.УстановитьПараметр("ДатаКон",       КонецДня(Объект.ПериодНачисленияДатаОкончания));
    Запрос.УстановитьПараметр("Организация",   Объект.Организация);
	Запрос.УстановитьПараметр("тблРабочееВремяПоПодразделениям",   тблРабочееВремяПоПодразделениям);
	
    Результат = Запрос.Выполнить();
    
    ВыборкаСотрудник = Результат.Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
	
	СправочникПодразделенияПустаяСсылка = Справочники.ПодразделенияОрганизаций.ПустаяСсылка();
	
    Пока ВыборкаСотрудник.Следующий() Цикл
		Если ВыборкаСотрудник.Сотрудник = NULL Тогда
			Продолжить;
		КонецЕсли;
		
		Если НЕ ЗначениеЗаполнено(ВыборкаСотрудник.Сотрудник.Организация) И (ВыборкаСотрудник.Результат <> NULL ИЛИ ВыборкаСотрудник.Дней <> NULL) Тогда
			ТекстНСТР = НСтр(
				"en='Charges %1, days %2, hours %3 of the driver ""%4"" can not be reflected in the document, so it is not listed in any company.';"
				"ru='Начисления %1, дни %2, часы %3 водителя ""%4"" не могут быть отражены в документе, так он не числится ни в одной организации.'");
			ТекстНСТР = СтрШаблон(ТекстНСТР, ВыборкаСотрудник.Результат, ВыборкаСотрудник.Дней, Окр(ВыборкаСотрудник.Время/3600,2), ВыборкаСотрудник.Сотрудник);
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстНСТР);
		Иначе
            ВыборкаДетали = ВыборкаСотрудник.Выбрать();
			КоличествоСтрокПоСотруднику = 0;
			
            Пока ВыборкаДетали.Следующий() Цикл
                НоваяСтрока = Объект.Начисления.Добавить();
                НоваяСтрока.Сотрудник  = ВыборкаДетали.Сотрудник;
                НоваяСтрока.Результат  = ?(ВыборкаДетали.Результат  = NULL,0,ВыборкаДетали.Результат);
                НоваяСтрока.ВидРасчета = ?(ВыборкаДетали.ВидРасчета = NULL,
										ПланыВидовРасчета.уатОсновныеНачисления.ОплатаПоЧасовомуТарифу, ВыборкаДетали.ВидРасчета);
                
				Если ВыборкаДетали.ВидРасчета = NULL ИЛИ
						ВыборкаДетали.ВидРасчета = ПланыВидовРасчета.уатОсновныеНачисления.ОплатаПоЧасовомуТарифу Тогда
                    НоваяСтрока.ОтработаноДней =  ?(ВыборкаДетали.Дней= NULL,0,ВыборкаДетали.Дней);
                    НоваяСтрока.ОтработаноЧасов =  ?(ВыборкаДетали.Время= NULL,0,Окр(ВыборкаДетали.Время/3600,2));
                КонецЕсли; 
                Если ВыборкаДетали.ВидРасчета = ПланыВидовРасчета.уатОсновныеНачисления.ОплатаЗаРемонт Тогда
                    НоваяСтрока.ОтработаноДней =  ?(ВыборкаДетали.ДнейВРемонте= NULL,0,ВыборкаДетали.ДнейВРемонте);
                    НоваяСтрока.ОтработаноЧасов =  ?(ВыборкаДетали.ВремяВРемонте= NULL,0,
													Окр(ВыборкаДетали.ВремяВРемонте/3600,2));
                КонецЕсли; 
                
                НоваяСтрока.ПодразделениеОрганизации = ?(ВыборкаДетали.ПодразделениеОрганизации = NULL, 
														СправочникПодразделенияПустаяСсылка, ВыборкаДетали.ПодразделениеОрганизации) ;
														
                КоличествоСтрокПоСотруднику = КоличествоСтрокПоСотруднику + 1;
            КонецЦикла;
			
			// Строка с заполненным отработанными часами и днями добавляется, только если по сотруднику
			// не было начислений с видом ОплатаПоЧасовомуТарифу.
			// Если не добавлять эту строку, то теряется информация по отработанным часам и дням.
			Если ВыборкаСотрудник.ЕстьЧасы = 0 И ВыборкаСотрудник.Дней <> NULL Тогда
				Если КоличествоСтрокПоСотруднику = 1 И НоваяСтрока.ОтработаноДней = 0 И НоваяСтрока.ОтработаноЧасов = 0 Тогда
					// Если у сотрудника есть только одна строка с заполненной суммой и незаполнеными днями и часами,
					// то дни и часы записываются в неё, и новая строка не создается
					НоваяСтрока.ОтработаноДней  =  ?(ВыборкаСотрудник.Дней= NULL,0,ВыборкаСотрудник.Дней);
					НоваяСтрока.ОтработаноЧасов =  ?(ВыборкаСотрудник.Время= NULL,0,
													Окр(ВыборкаСотрудник.Время/3600,2));
				Иначе
					// Иначе добавляется новая строка с нулевой суммой и заполненными днями и часами
					НоваяСтрока = Объект.Начисления.Добавить();
					НоваяСтрока.Сотрудник = ВыборкаСотрудник.Сотрудник;
					НоваяСтрока.ВидРасчета = ПланыВидовРасчета.уатОсновныеНачисления.ОплатаПоЧасовомуТарифу;
					НоваяСтрока.ПодразделениеОрганизации = ?(ВыборкаДетали.ПодразделениеОрганизации = NULL, 
					СправочникПодразделенияПустаяСсылка, ВыборкаСотрудник.ПодразделениеОрганизации) ;
					НоваяСтрока.ОтработаноДней  =  ?(ВыборкаСотрудник.Дней= NULL,0,ВыборкаСотрудник.Дней);
					НоваяСтрока.ОтработаноЧасов =  ?(ВыборкаСотрудник.Время= NULL,0,
													Окр(ВыборкаСотрудник.Время/3600,2));
				КонецЕсли;
			КонецЕсли; 
		КонецЕсли; 
    КонецЦикла;
КонецПроцедуры

&НаКлиенте
Процедура ЗаполнитьПоОсновнымНачислениямЗавершение(РезультатВопроса, ДополнительныеПараметры) Экспорт
    
    Если РезультатВопроса = КодВозвратаДиалога.Нет Тогда
        Возврат;
    Иначе
        Объект.Начисления.Очистить();
    КонецЕсли;  
    
    ЗаполнитьПоОсновнымНачислениямФрагмент();

КонецПроцедуры

&НаКлиенте
Процедура ЗаполнитьПоОсновнымНачислениямФрагмент()
    
    ЗаполнитьОсновнымиНачислениями();

КонецПроцедуры

&НаКлиенте
Процедура ВыборПериодаНачисленияЗавершение(Результат, ДополнительныеПараметры) Экспорт
	Если Результат = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Объект.ПериодРегистрации = НачалоМесяца(Результат.ДатаНачала);
	
	ОпределитьДатыПериодаНачисления();
	ОбновитьМесяцПредставление();
КонецПроцедуры

&НаКлиенте
Процедура НачисленияПриНачалеРедактирования(Элемент, НоваяСтрока, Копирование)
	Если НоваяСтрока = Истина
		И НЕ Копирование Тогда
		ТекСтрока = Элементы.Начисления.ТекущиеДанные;
		ТекСтрока.ПодразделениеОрганизации = Объект.Подразделение;
	КонецЕсли;
КонецПроцедуры

#КонецОбласти
