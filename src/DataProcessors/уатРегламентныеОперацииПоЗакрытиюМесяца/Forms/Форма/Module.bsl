
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	уатЗащищенныеФункцииСервер.уатОбработкаФормаПриСозданииНаСервере(Отказ, СтандартнаяОбработка, ДопПараметрыОткрытие);
	Если Отказ тогда
		Возврат;
	КонецЕсли;
	
	Пользователь = ПользователиКлиентСервер.АвторизованныйПользователь();
	Объект.Организация = 
		уатОбщегоНазначенияПовтИсп.ПолучитьЗначениеПоУмолчаниюПользователя(Пользователь, "ОсновнаяОрганизация");
	
	ТекДата  = ТекущаяДатаСеанса();
	ТекГод   = Год(ТекДата);
	ТекМесяц = Месяц(ТекДата);
	
	ПредставлениеПериодаРегистрации = Формат(ТекДата, "ДФ='MMMM yyyy'");
	Объект.ПериодРегистрации        = ТекДата;
	
	СвойстваРазделов                      = ДатыЗапретаИзмененияСлужебный.СвойстваРазделов();
	ИспользоватьДатыЗапретаЗагрузкиДанных = СвойстваРазделов.ДатыЗапретаЗагрузкиВнедрены;
	
	ДатаЗапрета = ПолучитьДатуЗапретаРедактирования();
	
	Если ЗначениеЗаполнено(ДатаЗапрета) Тогда
		ДатаЗапретаРедактирования = ДатаЗапрета;
	Иначе
		Элементы.ДатаЗапретаРедактирования.Видимость = Ложь;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ПредставлениеПериодаРегистрацииНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
		
	СтандартнаяОбработка = Ложь;
	
	ОбработчикЗакрытия = Новый ОписаниеОповещения("ПредставлениеПериодаРегистрацииНачалоВыбораЗавершение", ЭтотОбъект);
	ПараметрыФормы 	   = Новый Структура("Значение, РежимВыбораПериода", Объект.ПериодРегистрации, "МЕСЯЦ");
	
	ОткрытьФорму("Обработка.уатРегламентныеОперацииПоЗакрытиюМесяца.Форма.ВыборПериода",
		ПараметрыФормы, 
		ЭтотОбъект, 
		УникальныйИдентификатор,
		,
		, 
		ОбработчикЗакрытия,
		РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);

КонецПроцедуры

&НаКлиенте
Процедура ПредставлениеПериодаРегистрацииРегулирование(Элемент, Направление, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;

	Если Направление = 1 Тогда
		Объект.ПериодРегистрации = КонецМесяца(Объект.ПериодРегистрации) + 1;
	ИначеЕсли Направление = -1 Тогда
		Объект.ПериодРегистрации = НачалоМесяца(Объект.ПериодРегистрации - 1);
	КонецЕсли;

	ПредставлениеПериодаРегистрации = Формат(Объект.ПериодРегистрации, "ДФ='MMMM yyyy'");
	
КонецПроцедуры

&НаКлиенте
Процедура ПредставлениеПериодаРегистрацииОчистка(Элемент, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ВыполнитьЗакрытиеМесяца(Команда)
	
	Если КонецМесяца(Объект.ПериодРегистрации) <= КонецДня(ДатаЗапретаРедактирования) Тогда
		ПоказатьПредупреждение(Неопределено, НСтр("ru='Нельзя закрыть месяц, т.к. он относится к запрещенному для редактирования периоду!'"));
		Возврат;
	КонецЕсли;
	ИнициализироватьЗакрытиеМесяца();

КонецПроцедуры

#КонецОбласти
#Область СлужебныеПроцедурыИФункции

&НаСервере
Функция ПолучитьДатуЗапретаРедактирования()
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	ДатыЗапретаИзменения.Раздел,
	|	ДатыЗапретаИзменения.Объект,
	|	ДатыЗапретаИзменения.Пользователь,
	|	ДатыЗапретаИзменения.ДатаЗапрета,
	|	ДатыЗапретаИзменения.ОписаниеДатыЗапрета,
	|	ДатыЗапретаИзменения.Комментарий
	|ИЗ
	|	РегистрСведений.ДатыЗапретаИзменения КАК ДатыЗапретаИзменения
	|ГДЕ
	|	ДатыЗапретаИзменения.Пользователь = &Пользователь
	|	И ДатыЗапретаИзменения.Объект = &Объект";
	
	Запрос.УстановитьПараметр("Пользователь",  Перечисления.ВидыНазначенияДатЗапрета.ДляВсехПользователей);
	Запрос.УстановитьПараметр("Объект",        ПланыВидовХарактеристик.РазделыДатЗапретаИзменения.ПустаяСсылка());
	
	Выборка = Запрос.Выполнить().Выбрать();
	
	Если Выборка.Следующий() Тогда
		Возврат Выборка.ДатаЗапрета;
	Иначе
		Возврат Неопределено;
	КонецЕсли;
	
КонецФункции

&НаКлиенте
Процедура ПредставлениеПериодаРегистрацииНачалоВыбораЗавершение(ВыбранныйПериод, ДополнительныеПараметры) Экспорт 
	
	Если ВыбранныйПериод <> Неопределено Тогда
		
		Объект.ПериодРегистрации = ВыбранныйПериод;
		ПредставлениеПериодаРегистрации =
			Формат(ВыбранныйПериод, "ДФ='MMMM yyyy'");
		
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура РаспределениеДоходовРасходов()
	
	Запрос = Новый Запрос(
	"ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	уатРаспределениеДоходовРасходов.Ссылка КАК Документ,
	|	уатРаспределениеДоходовРасходов.Дата КАК ДатаДокумента,
	|	Организации.Ссылка КАК Организация,
	|	уатРаспределениеДоходовРасходов.Ссылка ЕСТЬ NULL КАК ДокументОтсутствует
	|ИЗ
	|	Справочник.Организации КАК Организации
	|		ЛЕВОЕ СОЕДИНЕНИЕ (ВЫБРАТЬ
	|			уатРаспределениеДоходовРасходов.Ссылка КАК Ссылка,
	|			уатРаспределениеДоходовРасходов.Дата КАК Дата,
	|			уатРаспределениеДоходовРасходов.Организация КАК Организация
	|		ИЗ
	|			Документ.уатРаспределениеДоходовРасходов КАК уатРаспределениеДоходовРасходов
	|		ГДЕ
	|			уатРаспределениеДоходовРасходов.Дата МЕЖДУ НАЧАЛОПЕРИОДА(&Дата, МЕСЯЦ) И КОНЕЦПЕРИОДА(&Дата, МЕСЯЦ)
	|			И уатРаспределениеДоходовРасходов.Проведен
	|			И НЕ уатРаспределениеДоходовРасходов.ПометкаУдаления) КАК уатРаспределениеДоходовРасходов
	|		ПО Организации.Ссылка = уатРаспределениеДоходовРасходов.Организация
	|ГДЕ
	|	Организации.Ссылка = &Организация
	|ИТОГИ ПО
	|	Организация");
	Запрос.УстановитьПараметр("Дата",        КонецМесяца(НачалоДня(Объект.ПериодРегистрации)));
	Запрос.УстановитьПараметр("Организация", Объект.Организация);
	
	ВыборкаОрганизация = Запрос.Выполнить().Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
	Пока ВыборкаОрганизация.Следующий() Цикл
		ДокСсылка = Документы.уатРаспределениеДоходовРасходов.ПустаяСсылка();
		ВыборкаДокумент = ВыборкаОрганизация.Выбрать();
		Пока ВыборкаДокумент.Следующий() Цикл
			Если ВыборкаДокумент.Документ <> NULL И ВыборкаДокумент.ДатаДокумента > ДокСсылка.Дата Тогда
				ДокСсылка = ВыборкаДокумент.Документ;
			КонецЕсли;
		КонецЦикла;
		
		Если ДокСсылка = Документы.уатРаспределениеДоходовРасходов.ПустаяСсылка() Тогда
			Док = Документы.уатРаспределениеДоходовРасходов.СоздатьДокумент();
			уатЗащищенныеФункцииСервер.уатДокументФормаЭлементаПриСозданииНаСервере(Ложь, Истина, Док);
			
			Док.Организация = ВыборкаОрганизация.Организация;
			Док.Дата = НачалоДня(Объект.ПериодРегистрации);
			Док.УстановитьНовыйНомер();
			Док.Комментарий = НСтр("en='Document is automatically created when executing scheduled jobs';ru='Документ создан автоматически при выполнении регламентного задания'");
		Иначе
			Док = ДокСсылка.ПолучитьОбъект();
			Док.Дата = НачалоДня(Объект.ПериодРегистрации);
		КонецЕсли;
		
		Попытка
			Док.Записать(РежимЗаписиДокумента.Проведение);
			ТекстНСТР = НСтр("en='Posted document';ru='Проведен документ'") + " """ + Док + """";
		Исключение
			ТекстНСТР = НСтр("en='During document posting';ru='При проведении документа'") + " """ + Док + " "" " + НСтр("en='errors occured:';ru='возникли ошибки:'") +" " + ОписаниеОшибки();
		КонецПопытки;
	КонецЦикла;
КонецПроцедуры

&НаСервере
Процедура РасчетФактическихДанныхПоДолгосрочномуПланированию()
	
	Запрос = Новый Запрос();
	Запрос.Текст = "ВЫБРАТЬ
	               |	уатСценарииПланирования.Ссылка КАК Ссылка
	               |ИЗ
	               |	Справочник.уатСценарииПланирования КАК уатСценарииПланирования
	               |ГДЕ
	               |	НЕ уатСценарииПланирования.ПометкаУдаления";
	Выборка = Запрос.Выполнить().Выбрать();
	Пока Выборка.Следующий() Цикл
		Док = Документы.уатРасчетФактическихДанныхПоДолгосрочномуПланированию.СоздатьДокумент();
		уатЗащищенныеФункцииСервер.уатДокументФормаЭлементаПриСозданииНаСервере(Ложь, Истина, Док);
		
		Док.Организация   = Объект.Организация;
		Док.ДатаНачала    = НачалоМесяца(Объект.ПериодРегистрации);
		Док.ДатаОкончания = КонецМесяца(Объект.ПериодРегистрации);
		Док.Сценарий      = Выборка.Ссылка;
		
		Док.УстановитьНовыйНомер();
		Док.Комментарий = НСтр("en='Document is automatically created when executing scheduled jobs';ru='Документ создан автоматически при выполнении регламентного задания'");
		Попытка
			Док.Записать(РежимЗаписиДокумента.Проведение);
			ТекстНСТР = НСтр("en='Posted document';ru='Проведен документ'") + " """ + Док + """";
		Исключение
			ТекстНСТР = НСтр("en='During document posting';ru='При проведении документа'") + " """ + Док + " "" " + НСтр("en='errors occured:';ru='возникли ошибки:'") +" " + ОписаниеОшибки();
		КонецПопытки;
	КонецЦикла;
		
КонецПроцедуры

&НаСервере
Процедура РасчетСводныхПараметровВыработки()
	
	Запрос = Новый Запрос();
	Запрос.Текст = "ВЫБРАТЬ
	               |	уатСценарииПланирования.Ссылка КАК Ссылка
	               |ИЗ
	               |	Справочник.уатСценарииПланирования КАК уатСценарииПланирования
	               |ГДЕ
	               |	НЕ уатСценарииПланирования.ПометкаУдаления";
	Выборка = Запрос.Выполнить().Выбрать();
	Пока Выборка.Следующий() Цикл
		Док = Документы.уатРасчетСводныхПараметровВыработки.СоздатьДокумент();
		уатЗащищенныеФункцииСервер.уатДокументФормаЭлементаПриСозданииНаСервере(Ложь, Истина, Док);
		
		Док.Организация   = Объект.Организация;
		Док.ДатаНачала    = НачалоМесяца(Объект.ПериодРегистрации);
		Док.ДатаОкончания = КонецМесяца(Объект.ПериодРегистрации);
		Док.Сценарий      = Выборка.Ссылка;
		
		Док.УстановитьНовыйНомер();
		Док.Комментарий = НСтр("en='Document is automatically created when executing scheduled jobs';ru='Документ создан автоматически при выполнении регламентного задания'");
		Попытка
			Док.Записать(РежимЗаписиДокумента.Проведение);
			ТекстНСТР = НСтр("en='Posted document';ru='Проведен документ'") + " """ + Док + """";
		Исключение
			ТекстНСТР = НСтр("en='During document posting';ru='При проведении документа'") + " """ + Док + " "" " + НСтр("en='errors occured:';ru='возникли ошибки:'") +" " + ОписаниеОшибки();
		КонецПопытки;
	КонецЦикла;
		
КонецПроцедуры

&НаКлиенте
Процедура ИнициализироватьЗакрытиеМесяца()
	
	Если РаспределениеДоходовРасходов Тогда
		РаспределениеДоходовРасходов();
	КонецЕсли;
	Если РасчетСводныхПараметровВыработки Тогда
		РасчетСводныхПараметровВыработки();
	КонецЕсли;
	Если РасчетФактическихДанныхПоДолгосрочномуПланированию Тогда
		РасчетФактическихДанныхПоДолгосрочномуПланированию();
	КонецЕсли;
	
	Если ВариантРасчета = 1 Тогда
		
		АктуализироватьДатуЗапретаРедактирования();
		
	КонецЕсли;
	
	ПоказатьПредупреждение(Неопределено, НСтр("ru='Закрытие месяца выполнено успешно'"));
	
КонецПроцедуры

// Процедура управляет актуализацией даты запрета редактирования в приложении
// 
&НаКлиенте
Процедура АктуализироватьДатуЗапретаРедактирования()
	
	ВыполнитьПереносДатыЗапретаРедактирования(КонецМесяца(Объект.ПериодРегистрации));
	
КонецПроцедуры

&НаСервере
Процедура ВыполнитьПереносДатыЗапретаРедактирования(Дата)
	
	НаборЗаписей = РегистрыСведений.ДатыЗапретаИзменения.СоздатьНаборЗаписей();
	НоваяСтрока = НаборЗаписей.Добавить();
	НоваяСтрока.Пользователь = Перечисления.ВидыНазначенияДатЗапрета.ДляВсехПользователей;
	НоваяСтрока.Объект = ПланыВидовХарактеристик.РазделыДатЗапретаИзменения.ПустаяСсылка();
	НоваяСтрока.ДатаЗапрета = Дата;
	НоваяСтрока.Комментарий = "(По умолчанию)";
	
	НаборЗаписей.Записать(Истина);
	
	ДатаЗапретаРедактирования = Дата;
	Элементы.ДатаЗапретаРедактирования.Видимость = Истина;
	
КонецПроцедуры

#КонецОбласти
