
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	ВидДокумента = Параметры.ВидДокумента;
	Организация = Параметры.Организация;
	ДатаКон = ТекущаяДата();
	НастроитьКомпоновщикОтбора();
КонецПроцедуры

#КонецОбласти


#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура НастройкаПериода(Команда)
	ДиалогПериода = Новый ДиалогРедактированияСтандартногоПериода();
	ДиалогПериода.Период.ДатаНачала = ДатаНач;
	ДиалогПериода.Период.ДатаОкончания = ДатаКон;
	ДиалогПериода.Показать(Новый ОписаниеОповещения("НастройкаПериодаЗавершение", ЭтотОбъект));
КонецПроцедуры

&НаКлиенте
Процедура НастройкаПериодаЗавершение(Период, ДополнительныеПараметры) Экспорт
    Если Период <> Неопределено Тогда
        ДатаНач = Период.ДатаНачала;
        ДатаКон = Период.ДатаОкончания;
    КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ОК(Команда)
	мсвДокументы = ПолучитьСписокДокументовСервер();
	Закрыть(мсвДокументы);
КонецПроцедуры

#КонецОбласти


#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура НастроитьКомпоновщикОтбора()
	
	Если ВидДокумента = 0 Тогда //заказ на ТС
		СхемаКомпоновкиДанных = РеквизитФормыВЗначение("Объект").ПолучитьМакет("ЗаказыНаТС");
	Иначе //МЛ
		СхемаКомпоновкиДанных = РеквизитФормыВЗначение("Объект").ПолучитьМакет("МаршрутныеЛисты");
	КонецЕсли;
	
	АдресСхемыКомпоновкиДанных = ПоместитьВоВременноеХранилище(СхемаКомпоновкиДанных, УникальныйИдентификатор);
	КомпоновщикНастроекОтбора.Инициализировать(Новый ИсточникДоступныхНастроекКомпоновкиДанных(АдресСхемыКомпоновкиДанных));
	КомпоновщикНастроекОтбора.ЗагрузитьНастройки(СхемаКомпоновкиДанных.НастройкиПоУмолчанию);
КонецПроцедуры

&НаСервере
Функция ПолучитьСписокДокументовСервер()
	КомпоновщикМакета = Новый КомпоновщикМакетаКомпоновкиДанных;

	Макет = КомпоновщикМакета.Выполнить(ПолучитьИзВременногоХранилища(АдресСхемыКомпоновкиДанных),
       КомпоновщикНастроекОтбора.ПолучитьНастройки(), , ,
       Тип("ГенераторМакетаКомпоновкиДанныхДляКоллекцииЗначений"));
	   
	НовыйПараметр = Макет.ЗначенияПараметров.Добавить();
	НовыйПараметр.Имя = "Организация"; НовыйПараметр.Значение = Организация;
	
	НовыйПараметр = Макет.ЗначенияПараметров.Добавить();
	НовыйПараметр.Имя = "ДатаНач"; НовыйПараметр.Значение = ДатаНач;
	
	НовыйПараметр = Макет.ЗначенияПараметров.Добавить();
	НовыйПараметр.Имя = "ДатаКон"; НовыйПараметр.Значение = КонецДня(ДатаКон);
	
	ПроцессорКомпоновки = Новый ПроцессорКомпоновкиДанных;
	ПроцессорКомпоновки.Инициализировать(Макет, , , Истина);
	
	ПроцессорВывода = Новый ПроцессорВыводаРезультатаКомпоновкиДанныхВКоллекциюЗначений;
	
	ТабДокументы = Новый ТаблицаЗначений;	
	ПроцессорВывода.УстановитьОбъект(ТабДокументы);
	ПроцессорВывода.Вывести(ПроцессорКомпоновки);
	
	ТабДокументы.Свернуть("Ссылка");
	мсвДокументы = ТабДокументы.ВыгрузитьКолонку("Ссылка");

	Возврат мсвДокументы;
КонецФункции

#КонецОбласти
