
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// начало блока стандартных операций
	ДопПараметрыОткрытие = Новый Структура("ИмяФормы", ИмяФормы);
	уатЗащищенныеФункцииСервер.уатОбработкаФормаПриСозданииНаСервере(Отказ, СтандартнаяОбработка, ДопПараметрыОткрытие);
	Если Отказ тогда
		Возврат;
	КонецЕсли;
	// конец блока стандартных операций
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	// начало блока стандартных операций
	уатЗащищенныеФункцииКлиент.уатОбработкаФормаПриОткрытии(Отказ, ДопПараметрыОткрытие);
	Если Отказ Тогда
		Возврат;
	КонецЕсли;
	// конец блока стандартных операций
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ОтметитьВсе(Команда)
	Для Каждого ТекСтрока Из Тарифы Цикл
		Если НЕ ТекСтрока.Недоступен Тогда
			ТекСтрока.Пометка = Истина;
		КонецЕсли;
	КонецЦикла;
КонецПроцедуры

&НаКлиенте
Процедура СнятьВсе(Команда)
	Для Каждого ТекСтрока Из Тарифы Цикл
		Если НЕ ТекСтрока.Недоступен Тогда
			ТекСтрока.Пометка = Ложь;
		КонецЕсли;
	КонецЦикла;
КонецПроцедуры

&НаКлиенте
Процедура ПрейскурантПриИзменении(Элемент)
	ЗагрузитьТарифы(Неопределено);
КонецПроцедуры

&НаКлиенте
Процедура ТарифыВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	Если Поле.Имя = "ТарифыТариф" Тогда
		ПоказатьЗначение(Неопределено, Элементы.Тарифы.ТекущиеДанные.Тариф);
	ИначеЕсли Поле.Имя = "ТарифыТарифСетка" Тогда
		ПоказатьЗначение(Неопределено, Элементы.Тарифы.ТекущиеДанные.ТарифСетка);
	КонецЕсли;
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#Область ЗагрузкаТарифовИзПрейскуранта

&НаКлиенте
Процедура ЗагрузитьТарифы(Команда)
	Если Прейскурант.Пустая() Тогда
		ПоказатьПредупреждение(Неопределено, "Не указан прейскурант");
		Возврат;
	КонецЕсли;
	
	Если Тарифы.Количество() <> 0 Тогда
		Оповещ = Новый ОписаниеОповещения("ЗагрузитьТарифыВопрос", ЭтотОбъект);
		ПоказатьВопрос(Оповещ, "Таблица тарифов будет очищена. Продолжить?", РежимДиалогаВопрос.ОКОтмена);
		Возврат;
	КонецЕсли;
	
	ЗагрузитьТарифыПрейскурантаСервер();
КонецПроцедуры

&НаКлиенте
Процедура ЗагрузитьТарифыВопрос(Результат, ДопПараметры) Экспорт
	Если Результат = КодВозвратаДиалога.ОК Тогда
		ЗагрузитьТарифыПрейскурантаСервер();
	КонецЕсли;
КонецПроцедуры

&НаСервере
Процедура ЗагрузитьТарифыПрейскурантаСервер()
	Запрос = Новый Запрос(
	"ВЫБРАТЬ
	|	уатТарифыТС.Ссылка КАК Тариф,
	|	уатТарифыТС.ПараметрВыработки КАК ПараметрВыработки,
	|	уатТарифыТС.НоменклатураУслуги КАК НоменклатураУслуги,
	|	уатТарифыТС.МетодРасчета КАК МетодРасчета,
	|	уатТарифыТС.УсловиеПримененияФиксТарифа КАК УсловиеПримененияФиксТарифа,
	|	уатТарифыТС.ТарифнаяСетка
	|		ИЛИ уатТарифыТС.СложныйТариф
	|		ИЛИ уатТарифыТС.МетодРасчета = ЗНАЧЕНИЕ(Перечисление.уатМетодыРасчетаПоТарифам.ПроцентомОтСуммы) КАК Недоступен
	|ИЗ
	|	Справочник.уатТарифыТС КАК уатТарифыТС
	|ГДЕ
	|	уатТарифыТС.Владелец = &Прейскурант
	|	И НЕ уатТарифыТС.ПометкаУдаления
	|	И НЕ уатТарифыТС.ЭтоГруппа");
	Запрос.УстановитьПараметр("Прейскурант", Прейскурант);
	тблТарифы = Запрос.Выполнить().Выгрузить();
	тблТарифы.Колонки.Добавить("Пояснение", Новый ОписаниеТипов("Строка",,,, Новый КвалификаторыСтроки(100)));
	
	// Недоступными к обработке также являются тарифы с нестандартными видами областей действия
	// стандартными считаем "Равно", "В списке", "В группе"
	Для Каждого ТекСтрока Из тблТарифы Цикл
		Если ТекСтрока.Недоступен Тогда
			ТекСтрока.Пояснение = "Тарифная сетка, сложный тариф или тариф ""Процентом от суммы""";
		КонецЕсли;
					
		НастройкаКомпоновкиОтбор = ТекСтрока.Тариф.ОбластьДействия.Получить();
		Если НастройкаКомпоновкиОтбор = Неопределено Тогда
			Продолжить;
		КонецЕсли;
		
		НастройкаКомпоновкиОтбор = НастройкаКомпоновкиОтбор.Отбор;
		Если НастройкаКомпоновкиОтбор.Элементы.Количество() = 0 Тогда
			Продолжить;
		КонецЕсли;
		
		Для Каждого ТекОтбор Из НастройкаКомпоновкиОтбор.Элементы Цикл
			Если ТипЗнч(ТекОтбор) = Тип("ГруппаЭлементовОтбораКомпоновкиДанных") Тогда
				ТекСтрока.Недоступен = Истина;
				ТекСтрока.Пояснение = "Отбор содержит группу условий";
				Прервать;
			КонецЕсли;
			
			Если ТекОтбор.ВидСравнения <> ВидСравненияКомпоновкиДанных.Равно
				И ТекОтбор.ВидСравнения <> ВидСравненияКомпоновкиДанных.ВСписке
				И ТекОтбор.ВидСравнения <> ВидСравненияКомпоновкиДанных.ВИерархии
				И ТекОтбор.ВидСравнения <> ВидСравненияКомпоновкиДанных.ВСпискеПоИерархии Тогда
				ТекСтрока.Недоступен = Истина;
				ТекСтрока.Пояснение = "Отбор содержит недопустимые виды сравнения";
				Прервать;
			КонецЕсли;
			
			мИмя = Строка(ТекОтбор.ЛевоеЗначение);
			мИмя = СтрЗаменить(мИмя, ".", "");
			Если Метаданные.Перечисления.уатВидыОбластейДействияТарифовТС.ЗначенияПеречисления.Найти(мИмя) = Неопределено Тогда
				ТекСтрока.Недоступен = Истина;
				ТекСтрока.Пояснение = "Отбор содержит недопустимые поля сравнения";
				Прервать;
			КонецЕсли;
		КонецЦикла;
	КонецЦикла;
	
	Тарифы.Загрузить(тблТарифы);
		
КонецПроцедуры

#КонецОбласти


#Область СозданиеНовыхТарифовСетка

&НаКлиенте
Процедура СоздатьТарифыСетка(Команда)
	СоздатьТарифыСеткаСервер();
КонецПроцедуры

&НаСервере
Процедура СоздатьТарифыСеткаСервер()
	тблГруппыТарифовСетки = Тарифы.Выгрузить().Скопировать();
	тблГруппыТарифовСетки.Свернуть("ПараметрВыработки, НоменклатураУслуги, МетодРасчета, УсловиеПримененияФиксТарифа");
	
	ЕстьРеквизитКоличествоБесплатныхЕдиниц = уатОбщегоНазначенияТиповые.уатЕстьРеквизитСправочника("КоличествоБесплатныхЕдиниц", Метаданные.Справочники.уатТарифыТС);
	
	ВсегоТарифовСоздано = 0;
	
	Для Каждого ТекГруппа Из тблГруппыТарифовСетки Цикл
		СтруктураПоиска = Новый Структура("ПараметрВыработки, НоменклатураУслуги, МетодРасчета, УсловиеПримененияФиксТарифа");
		ЗаполнитьЗначенияСвойств(СтруктураПоиска, ТекГруппа);
		СтруктураПоиска.Вставить("Пометка", Истина);
		мсвТарифыГруппы = Тарифы.НайтиСтроки(СтруктураПоиска);
		
		Если мсвТарифыГруппы.Количество() = 0 Тогда
			Продолжить;
		КонецЕсли;
		
		НовыйТарифСетка = Справочники.уатТарифыТС.СоздатьЭлемент();
		НовыйТарифСетка.Наименование = "" + ТекГруппа.НоменклатураУслуги
				+ " (" + ?(ЗначениеЗаполнено(ТекГруппа.ПараметрВыработки), ТекГруппа.ПараметрВыработки, "Все параметры выработки") + ")";
		НовыйТарифСетка.Владелец                    = Прейскурант;
		НовыйТарифСетка.ТарифнаяСетка               = Истина;
		ЗаполнитьЗначенияСвойств(НовыйТарифСетка, ТекГруппа,
			"ПараметрВыработки, НоменклатураУслуги, МетодРасчета, УсловиеПримененияФиксТарифа");
		ЗаполнитьЗначенияСвойств(НовыйТарифСетка, мсвТарифыГруппы[0].Тариф,
			"ТипТочкиМаршрута, ТипПункта, ВидУпаковки, ИспользуютсяГеозоны, ВидСкладскойОперации, БазаТарифа, ТипКонтейнера");
		
		Если ЕстьРеквизитКоличествоБесплатныхЕдиниц Тогда
			НовыйТарифСетка.КоличествоБесплатныхЕдиниц = мсвТарифыГруппы[0].Тариф.КоличествоБесплатныхЕдиниц;
		КонецЕсли;
				
		Для Каждого ТекТариф Из мсвТарифыГруппы Цикл
			НоваяСтрокаСетки = НовыйТарифСетка.СтрокиТарифнойСетки.Добавить();
			НоваяСтрокаСетки.ID = Новый УникальныйИдентификатор;
			НоваяСтрокаСетки.МинимальнаяВыработка = ТекТариф.Тариф.МинимальнаяВыработка;
			НоваяСтрокаСетки.МинимальнаяСтоимость = ТекТариф.Тариф.МинимальнаяСтоимость;
			НоваяСтрокаСетки.СпособЗаполненияКоличества = ТекТариф.Тариф.СпособЗаполненияКоличества;
			НоваяСтрокаСетки.Тариф = ТекТариф.Тариф.Тариф;
			
			НастройкаКомпоновкиОтбор = ТекТариф.Тариф.ОбластьДействия.Получить();
			Если НастройкаКомпоновкиОтбор = Неопределено Тогда
				Продолжить;
			КонецЕсли;
			
			НастройкаКомпоновкиОтбор = НастройкаКомпоновкиОтбор.Отбор;
					
			Для Каждого ТекОбласть Из НастройкаКомпоновкиОтбор.Элементы Цикл
				Если НЕ ТекОбласть.Использование Тогда
					Продолжить;
				КонецЕсли;
				
				Если ТекОбласть.ВидСравнения = ВидСравненияКомпоновкиДанных.ВСписке Тогда
					Для Каждого ТекЗначениеОтбора Из ТекОбласть.ПравоеЗначение Цикл
						НоваяОбластьТарифа = НовыйТарифСетка.ОбластиТарифнойСетки.Добавить();
						НоваяОбластьТарифа.ID = НоваяСтрокаСетки.ID;
						НоваяОбластьТарифа.ВидОбластиДействия = Перечисления.уатВидыОбластейДействияТарифовТС[Строка(ТекОбласть.ЛевоеЗначение)];
						НоваяОбластьТарифа.ЗначениеОбластиДействия = ТекЗначениеОтбора.Значение;
						НоваяОбластьТарифа.ЭтоГруппа = ТекЗначениеОтбора.Значение.ЭтоГруппа;
					КонецЦикла;
				Иначе
					НоваяОбластьТарифа = НовыйТарифСетка.ОбластиТарифнойСетки.Добавить();
					НоваяОбластьТарифа.ID = НоваяСтрокаСетки.ID;
					НоваяОбластьТарифа.ВидОбластиДействия = Перечисления.уатВидыОбластейДействияТарифовТС[Строка(ТекОбласть.ЛевоеЗначение)];
					НоваяОбластьТарифа.ЗначениеОбластиДействия = ТекОбласть.ПравоеЗначение;
					НоваяОбластьТарифа.ЭтоГруппа = ТекОбласть.ПравоеЗначение.ЭтоГруппа;
				КонецЕсли;
			КонецЦикла;
			
			УдаляемыйТариф = ТекТариф.Тариф.ПолучитьОбъект();
			УдаляемыйТариф.УстановитьПометкуУдаления(Истина);
			
		КонецЦикла;
		
		НовыйТарифСетка.Записать();
		ВсегоТарифовСоздано = ВсегоТарифовСоздано + 1;
				
		Для Каждого ТекТариф Из мсвТарифыГруппы Цикл
			ТекТариф.ТарифСетка = НовыйТарифСетка.Ссылка;
			ТекТариф.Пояснение  = "Создан новый тариф";
		КонецЦикла;
	КонецЦикла;
	
	ОбщегоНазначенияКлиентСервер.СообщитьПользователю("Создано тарифов всего: " + ВсегоТарифовСоздано);
КонецПроцедуры

#КонецОбласти

#КонецОбласти
