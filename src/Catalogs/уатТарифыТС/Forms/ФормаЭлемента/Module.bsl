
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	уатЗащищенныеФункцииСервер.уатСправочникФормаЭлементаПриСозданииНаСервере(Отказ, СтандартнаяОбработка, Объект, ЭтотОбъект, ДопПараметрыОткрытие);
	Если Отказ тогда
		Возврат;
	КонецЕсли;
	
	// Запрет на просмотр карточки тарифа для внешнего пользователя.
	Если уатОбщегоНазначения.ПроверкаВнешнегоПользователя() Тогда
		Отказ = Истина;
		Возврат;
	КонецЕсли;
	
	// СтандартныеПодсистемы.ВерсионированиеОбъектов
	ВерсионированиеОбъектов.ПриСозданииНаСервере(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ВерсионированиеОбъектов
	
	НастроитьКомпоновщикОтбора();
	
	Если НЕ ПравоДоступа("Редактирование", Метаданные.Справочники.уатТарифыТС) Тогда
		Элементы.ГруппаСтраницаОбластьДействия.ТолькоПросмотр = Истина;
		Элементы.СложныйТариф.ТолькоПросмотр = Истина;
		Элементы.ГруппаМинимальнаяВыработка.ТолькоПросмотр = Истина;
		Элементы.ФормаРедактированиеТарифов.Доступность = Ложь;
	КонецЕсли;
	
	Если Объект.Владелец.ПрейскурантПоставщика Тогда
		//Элементы.ПараметрВыработки.РежимВыбораИзСписка=Истина;
		Запрос = Новый Запрос(
		"ВЫБРАТЬ РАЗРЕШЕННЫЕ
		|	уатПараметрыВыработки.Ссылка
		|ИЗ
		|	Справочник.уатПараметрыВыработки КАК уатПараметрыВыработки
		|ГДЕ
		|	(уатПараметрыВыработки.ИспользоватьДляЗаказовИПотребности
		|			ИЛИ уатПараметрыВыработки.ИспользоватьДляМаршрутныхЛистов)
		|
		|УПОРЯДОЧИТЬ ПО
		|	уатПараметрыВыработки.Наименование");
		//Элементы.ПараметрВыработки.СписокВыбора.Очистить();
		//Для Каждого ТекСтрока Из Запрос.Выполнить().Выгрузить() Цикл
		//	Элементы.ПараметрВыработки.СписокВыбора.Добавить(ТекСтрока.Ссылка);
		//КонецЦикла;
		Элементы.ПараметрВыработки.СписокВыбора.ЗагрузитьЗначения(Запрос.Выполнить().Выгрузить().ВыгрузитьКолонку("Ссылка"));
	КонецЕсли;
	
	МинВыработкаВременной = уатОбщегоНазначения.уатВремяВЧЧ_ММ(Объект.МинимальнаяВыработка*3600);
	
	ВладелецПриИзмененииНаСервере();	
	СложныйТарифПереключатель = ?(Объект.СложныйТариф, "Сложный тариф", "Простой тариф");
	
	УстановитьОтборПараметраВыработки();
	
	Элементы.МетодРасчета.СписокВыбора.Добавить(Перечисления.уатМетодыРасчетаПоТарифам.ПоПараметруВыработки,,, БиблиотекаКартинок.уатТарифПоВыработке);
	Элементы.МетодРасчета.СписокВыбора.Добавить(Перечисления.уатМетодыРасчетаПоТарифам.ФиксированнойСуммой,,, БиблиотекаКартинок.уатТарифФиксированный);
	Элементы.МетодРасчета.СписокВыбора.Добавить(Перечисления.уатМетодыРасчетаПоТарифам.ПроцентомОтСуммы,,, БиблиотекаКартинок.уатТарифПроцентом);
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	уатЗащищенныеФункцииКлиент.уатСправочникФормаЭлементаПриОткрытии(Отказ, ДопПараметрыОткрытие);
	Если Отказ Тогда
		Возврат;
	КонецЕсли;
	
	УстановитьВидимость();
	
КонецПроцедуры

&НаСервере
Процедура ПередЗаписьюНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)
	Для Каждого ТекОтбор Из КомпоновщикНастроекОтбора.Настройки.Отбор.Элементы Цикл
		Если ТипЗнч(ТекОтбор) = Тип("ГруппаЭлементовОтбораКомпоновкиДанных") Тогда
			Отказ = Истина;
			
			ТекстНСТР = НСтр("en='Prohibited adding group to tariff owner scope!';ru='Запрещено добавление групп в область действия тарифа!'");
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстНСТР);
			Возврат;
		КонецЕсли;
	КонецЦикла;
	
	СохранитьНастройкиОтбораОбластиДействий(ТекущийОбъект);
КонецПроцедуры

&НаКлиенте
Процедура ПослеЗаписи(ПараметрыЗаписи)
	Оповестить("ИзменениеТарифаТС");
КонецПроцедуры

#КонецОбласти


#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура СложныйТарифПриИзменении(Элемент)
	Объект.СложныйТариф = (СложныйТарифПереключатель = "Сложный тариф");
	
	Если Объект.СложныйТариф Тогда
		Объект.Тариф = 0;
	Иначе
		Объект.ГруппировкаТарифа1 = Неопределено;
		Объект.ГруппировкаТарифа2 = Неопределено;
		Объект.ГруппировкаТарифа3 = Неопределено;
		Объект.ГруппировкаТарифа4 = Неопределено;
		Объект.Тарифы.Очистить();
		Если Объект.ТарифнаяСетка Тогда
			Объект.ЗначенияТарифнойСетки.Очистить();
		КонецЕсли;
	КонецЕсли;
	
	Если Объект.МетодРасчета = ПредопределенноеЗначение("Перечисление.уатМетодыРасчетаПоТарифам.ФиксированнойСуммой")
		ИЛИ Объект.МетодРасчета = ПредопределенноеЗначение("Перечисление.уатМетодыРасчетаПоТарифам.ПроцентомОтСуммы")
		ИЛИ Объект.СложныйТариф Тогда
		Объект.МинимальнаяВыработка = 0;
		МинВыработкаВременной = 0;
	КонецЕсли;
	
	Модифицированность = Истина;
	УстановитьВидимость();
КонецПроцедуры

&НаКлиенте
Процедура МетодРасчетаПриИзменении(Элемент)
	
	Если Объект.МетодРасчета = ПредопределенноеЗначение("Перечисление.уатМетодыРасчетаПоТарифам.ПроцентомОтСуммы") Тогда
		Объект.ПараметрВыработки = Неопределено;
		ПараметрВыработкиПриИзмененииДоп();
		СформироватьНадписьЕИ();
		Объект.МинимальнаяВыработка = 0;
		Объект.МинимальнаяСтоимость = 0;
		КомпоновщикНастроекОтбора.Настройки.Отбор.Элементы.Очистить();
		Объект.СложныйТариф = Ложь;
		СложныйТарифПриИзменении(Неопределено);
		//{СКЛ}
		Объект.БазаТарифа = Неопределено;
		Объект.ВидУпаковки = Неопределено;
		//{/СКЛ}
	ИначеЕсли Объект.МетодРасчета = ПредопределенноеЗначение("Перечисление.уатМетодыРасчетаПоТарифам.ФиксированнойСуммой") Тогда
		Объект.МинимальнаяВыработка = 0;
		Объект.МинимальнаяСтоимость = 0;
		//{СКЛ}
		Объект.БазаТарифа = Неопределено;
		Объект.ВидУпаковки = Неопределено;
		//{/СКЛ}
	Иначе
		Объект.УсловиеПримененияФиксТарифа = 0;
	КонецЕсли;
	
	УстановитьВидимость();
	
КонецПроцедуры

&НаКлиенте
Процедура СкидкаПриИзменении(Элемент)
	// скидка не может быть больше 100%
	Если Объект.Скидка Тогда
		Если Объект.СложныйТариф Тогда
			Для Каждого ТекСтрокаРасчета Из Объект.Тарифы Цикл
				Если ТекСтрокаРасчета.Тариф > 100 Тогда
					ТекСтрокаРасчета.Тариф = 100;
				КонецЕсли;
			КонецЦикла;
		ИначеЕсли Объект.Тариф > 100 Тогда
			Объект.Тариф = 100;
		КонецЕсли;
		
		Объект.ДобавлятьСкидкуНаценкуОтдельнойСтрокой = Ложь;
	КонецЕсли;
	
	УстановитьВидимость();
КонецПроцедуры

&НаКлиенте
Процедура УсловиеПримененияФиксТарифаПриИзменении(Элемент)
	Если Объект.УсловиеПримененияФиксТарифа = 1 Тогда
		Объект.МинимальнаяВыработка = 0;
	КонецЕсли;
	
	УстановитьВидимость();
КонецПроцедуры

&НаКлиенте
Процедура ГруппировкаТарифаПриИзменении(Элемент)
	УстановитьВидимость();
КонецПроцедуры

&НаКлиенте
Процедура ГруппировкаТарифаНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	ВыборГруппировкиТарифаОткрытьФорму(Элемент);
	СтандартнаяОбработка = Ложь;
КонецПроцедуры

&НаКлиенте
Процедура ПараметрВыработкиПриИзменении(Элемент)
	
	ПараметрВыработкиПриИзмененииДоп();
	СформироватьНадписьЕИ();
	УстановитьВидимость();
	
КонецПроцедуры

&НаКлиенте
Процедура ПараметрВыработкиПриИзмененииДоп()
	Если Объект.ПараметрВыработки <> ПредопределенноеЗначение("Справочник.уатПараметрыВыработки.КоличествоТочекПоТипуПункта") Тогда
		Объект.ТипПункта = Неопределено;
	КонецЕсли;
	Если Объект.ПараметрВыработки <> ПредопределенноеЗначение("Справочник.уатПараметрыВыработки.КоличествоТочекПоВидуОперации") Тогда
		Объект.ТипТочкиМаршрута = Неопределено;
	КонецЕсли;
	Если Объект.ПараметрВыработки <> ПредопределенноеЗначение("Справочник.уатПараметрыВыработки.КоличествоУпаковок") Тогда
		Объект.ВидУпаковки = Неопределено;
	КонецЕсли;
	Если Объект.ПараметрВыработки <> ПредопределенноеЗначение("Справочник.уатПараметрыВыработки.СкладскаяОбработка") Тогда
		Объект.ВидСкладскойОперации = Неопределено;
		Объект.БазаТарифа = Неопределено;
	КонецЕсли;
	Если Объект.ПараметрВыработки <> ПредопределенноеЗначение("Справочник.уатПараметрыВыработки.КоличествоКонтейнеров") Тогда
		Объект.ТипКонтейнера = Неопределено;
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ВидУпаковкиПриИзменении(Элемент)
	
	УстановитьВидимость();
	
КонецПроцедуры

&НаКлиенте
Процедура ТипКонтейнераПриИзменении(Элемент)
	
	УстановитьВидимость();
	
КонецПроцедуры

&НаКлиенте
Процедура МинимальнаяВыработкаПриИзменении(Элемент)
	МинВыработкаВременной = уатОбщегоНазначения.уатВремяВЧЧ_ММ(Объект.МинимальнаяВыработка*3600);
	уатЗащищенныеФункцииСервер.КонтрольВводаВремени(МинВыработкаВременной);
	Объект.МинимальнаяСтоимость = Объект.МинимальнаяВыработка * Объект.Тариф;
КонецПроцедуры

&НаКлиенте
Процедура МинВыработкаВременнойПриИзменении(Элемент)
	уатЗащищенныеФункцииСервер.КонтрольВводаВремени(МинВыработкаВременной);
	Объект.МинимальнаяВыработка = уатОбщегоНазначения.уатВремяВСекунды(МинВыработкаВременной)/3600;
	Объект.МинимальнаяСтоимость = Объект.МинимальнаяВыработка * Объект.Тариф;
КонецПроцедуры

&НаКлиенте
Процедура ТарифПриИзменении(Элемент)
	Объект.МинимальнаяСтоимость = Объект.МинимальнаяВыработка * Объект.Тариф;
КонецПроцедуры

&НаКлиенте
Процедура МинимальнаяСтоимостьПриИзменении(Элемент)
	Объект.МинимальнаяВыработка = ?(Объект.Тариф = 0, 0, Объект.МинимальнаяСтоимость / Объект.Тариф);
КонецПроцедуры

&НаКлиенте
Процедура ВладелецПриИзменении(Элемент)
	
	ВладелецПриИзмененииНаСервере();
	
	УстановитьВидимость();
	
КонецПроцедуры

&НаСервере
Процедура ВладелецПриИзмененииНаСервере()
	ВалютаСтрокой = Строка(Объект.Владелец.Валюта);
	Валюта = СокрЛП(Лев(ВалютаСтрокой,5));
КонецПроцедуры

&НаКлиенте
Процедура ТарифнаяСеткаПриИзменении(Элемент)
	
	Если Объект.ТарифнаяСетка Тогда
		Объект.МинимальнаяВыработка = 0;
		Объект.МинимальнаяСтоимость = 0;
		Объект.СпособЗаполненияКоличества = 0;
		КомпоновщикНастроекОтбора.Настройки.Отбор.Элементы.Очистить();
		Объект.Тариф = 0;
	Иначе
		Объект.СтрокиТарифнойСетки.Очистить();
		Объект.ОбластиТарифнойСетки.Очистить();
		Объект.ЗначенияТарифнойСетки.Очистить();
	КонецЕсли;
	
	УстановитьВидимость();
	
КонецПроцедуры

&НаКлиенте
Процедура БазаТарифаПриИзменении(Элемент)
	УстановитьВидимость();
КонецПроцедуры

&НаКлиенте
Процедура ВидСкладскойОперацииПриИзменении(Элемент)
	УстановитьВидимость();
КонецПроцедуры

&НаКлиенте
Процедура ТарифнаяСеткаРасширеннаяПодсказкаОбработкаНавигационнойСсылки(Элемент, НавигационнаяСсылкаФорматированнойСтроки, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	тРекомендацияСсылкаНажатие(Неопределено);
	
КонецПроцедуры

&НаКлиенте
Процедура тРекомендацияСсылкаНажатие(Элемент)
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("Заголовок", "Инструкция по заполнению тарифной сетки");
	ПараметрыФормы.Вставить("ИмяМакета", "Справочник.уатТарифыТС.ИнструкцияТарифнаяСетка");
	ОткрытьФорму("ОбщаяФорма.уатДополнительноеОписание",ПараметрыФормы);
	
КонецПроцедуры

&НаКлиенте
Процедура тРекомендацияГеозоныСсылкаНажатие(Элемент)
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("Заголовок", "Инструкция по заполнению тарифов с геозонами");
	ПараметрыФормы.Вставить("ИмяМакета", "Справочник.уатТарифыТС.ИнструкцияГеозоны");
	ОткрытьФорму("ОбщаяФорма.уатДополнительноеОписание",ПараметрыФормы);
	
КонецПроцедуры

#КонецОбласти


#Область ОбработчикиСобытийЭлементовТаблицыФормы

&НаКлиенте
Процедура НастройкиОтбораПриИзменении(Элемент)
	Модифицированность = Истина;
КонецПроцедуры

#Область ОтладочныйРежим
&НаКлиенте
Процедура СтрокиТарифнойСеткиПриНачалеРедактирования(Элемент, НоваяСтрока, Копирование)
	Если НоваяСтрока Тогда
		Элементы.СтрокиТарифнойСетки.ТекущиеДанные.ID = Новый УникальныйИдентификатор;
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура СтрокиТарифнойСеткиПриАктивизацииСтроки(Элемент)
	ТекСтрока = Элементы.СтрокиТарифнойСетки.ТекущиеДанные;
	Если ТекСтрока = Неопределено ИЛИ ТекСтрока.ID = "" Тогда
		ОтборСтрок = Новый ФиксированнаяСтруктура(Новый Структура);
	Иначе
		ОтборСтрок = Новый ФиксированнаяСтруктура(Новый Структура("ID", ТекСтрока.ID));
	КонецЕсли;
			
	Элементы.ЗначенияТарифнойСетки.ОтборСтрок = ОтборСтрок;
	Элементы.ОбластиТарифнойСетки.ОтборСтрок = ОтборСтрок;
КонецПроцедуры

&НаКлиенте
Процедура ЗначенияТарифнойСеткиПриНачалеРедактирования(Элемент, НоваяСтрока, Копирование)
	ТекСтрока = Элементы.СтрокиТарифнойСетки.ТекущиеДанные;
	Если ТекСтрока = Неопределено ИЛИ ТекСтрока.ID = "" Тогда
		Возврат;
	КонецЕсли;
	
	Элементы.ЗначенияТарифнойСетки.ТекущиеДанные.ID = ТекСтрока.ID;
КонецПроцедуры

&НаКлиенте
Процедура ОбластиТарифнойСеткиПриНачалеРедактирования(Элемент, НоваяСтрока, Копирование)
	ТекСтрока = Элементы.СтрокиТарифнойСетки.ТекущиеДанные;
	Если ТекСтрока = Неопределено ИЛИ ТекСтрока.ID = "" Тогда
		Возврат;
	КонецЕсли;
	
	Элементы.ОбластиТарифнойСетки.ТекущиеДанные.ID = ТекСтрока.ID;
КонецПроцедуры
#КонецОбласти 

#КонецОбласти


#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура РедактированиеТарифов(Команда)
	Если Объект.МетодРасчета = ПредопределенноеЗначение("Перечисление.уатМетодыРасчетаПоТарифам.ПроцентомОтСуммы") Тогда
		ТекстНСТР = НСтр("en='Editing rates with method of calculating ""Percent of amount"" in processing is not available!';ru='Редактирование тарифов с методом расчета ""Процентом от суммы"" в обработке недоступно!'");
		ПоказатьПредупреждение(Неопределено, ТекстНСТР);
		Возврат;
	КонецЕсли;
	
	Если Объект.Ссылка.Пустая() ИЛИ Модифицированность Тогда
		//ПоказатьПредупреждение(Неопределено, "Для выполнения данной операции необходимо записать элемент!");
		ОповещениеОтвет = Новый ОписаниеОповещения("РедактированиеТарифовЗаписатьОтвет", ЭтотОбъект);
		ТекстНСТР = НСтр("en='Before performing this operation it is necessary to record the item. Continue?';ru='Перед выполнением данной операции необходимо записать элемент. Продолжить?'");
		ПоказатьВопрос(ОповещениеОтвет, ТекстНСТР, РежимДиалогаВопрос.ОКОтмена);
		Возврат;
	КонецЕсли;
	
	РедактированиеТарифовОткрытьФорму();
КонецПроцедуры

&НаКлиенте
Процедура РедактированиеТарифовЗаписатьОтвет(Результат, ДопПараметры) Экспорт
	Если Результат = КодВозвратаДиалога.ОК Тогда
		Записать();
		Если НЕ Объект.Ссылка.Пустая() И НЕ Модифицированность Тогда
			РедактированиеТарифовОткрытьФорму();
		КонецЕсли;
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура РедактированиеТарифовОткрытьФорму()
	ПараметрыФормы = Новый Структура();
	ПараметрыФормы.Вставить("Тариф",             Объект.Ссылка);
	//ПараметрыФормы.Вставить("Прейскурант",       Объект.Владелец);
	//ПараметрыФормы.Вставить("ПараметрВыработки", Объект.ПараметрВыработки);
	//ПараметрыФормы.Вставить("СложныйТариф",      Объект.СложныйТариф);
	//ПараметрыФормы.Вставить("ТарифнаяСетка",     Объект.ТарифнаяСетка);
	//ПараметрыФормы.Вставить("МетодРасчета",      Объект.МетодРасчета);
	
	ОткрытьФорму("Обработка.уатРедактированиеТарифов_уэ.Форма", ПараметрыФормы,,,,, Новый ОписаниеОповещения("ПеречитатьОбъект", ЭтотОбъект));
КонецПроцедуры

&НаКлиенте
Процедура НастроитьНормуБесплатногоХранения(Команда)
	ОткрытьФорму("РегистрСведений.уатНормыБесплатногоХранения_уэ.ФормаСписка",, ЭтотОбъект,,,,, РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
КонецПроцедуры

#Область ОтладочныйРежим

&НаКлиенте
Процедура ОтладочныйРежимСетка(Команда)
	Элементы.ГруппаТарифнаяСетка.Видимость = Истина;
КонецПроцедуры
#КонецОбласти

#КонецОбласти


#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура НастроитьКомпоновщикОтбора()
	ЭтоПроф = уатОбщегоНазначенияПовтИсп.ВариантПоставкиПРОФ();
	
	Если Объект.Владелец.ПрейскурантПоставщика Тогда
		Если ЭтоПроф Тогда
			СхемаКомпоновкиДанных = Справочники.уатТарифыТС.ПолучитьМакет("КомпоновкаДанныхОбластьДействияКонтрагенты_проф");
		Иначе
			СхемаКомпоновкиДанных = Справочники.уатТарифыТС.ПолучитьМакет("КомпоновкаДанныхОбластьДействияКонтрагенты");
		КонецЕсли;
	Иначе
		Если ЭтоПроф Тогда
			СхемаКомпоновкиДанных = Справочники.уатТарифыТС.ПолучитьМакет("КомпоновкаДанныхОбластьДействия_проф");
		Иначе //Логистика, Стандарт
			СхемаКомпоновкиДанных = Справочники.уатТарифыТС.ПолучитьМакет("КомпоновкаДанныхОбластьДействия");
		КонецЕсли;
	КонецЕсли;
	
	АдресСхемыКомпоновкиДанных = ПоместитьВоВременноеХранилище(СхемаКомпоновкиДанных, УникальныйИдентификатор);
	
	КомпоновщикНастроекОтбора.Инициализировать(Новый ИсточникДоступныхНастроекКомпоновкиДанных(АдресСхемыКомпоновкиДанных));
	
	Если НЕ Объект.Ссылка.Пустая() Тогда
		ЗагрузитьНастройкиОтбораОбластиДействий();
	КонецЕсли;
КонецПроцедуры

&НаСервере
Процедура ЗагрузитьНастройкиОтбораОбластиДействий()
	ТекОбъект = РеквизитФормыВЗначение("Объект");
	ТекНастройки = ТекОбъект.ОбластьДействия.Получить();
	Если ТипЗнч(ТекНастройки) = Тип("НастройкиКомпоновкиДанных") Тогда
		КомпоновщикНастроекОтбора.ЗагрузитьНастройки(ТекНастройки);
	КонецЕсли;
КонецПроцедуры

&НаСервере
Процедура СохранитьНастройкиОтбораОбластиДействий(ТекОбъект)
	Если ТекОбъект.ТарифнаяСетка Тогда
		ТекОбъект.ОбластьДействия = Неопределено;
	Иначе
		ТекОбъект.ОбластьДействия = Новый ХранилищеЗначения(КомпоновщикНастроекОтбора.Настройки);
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура УстановитьВидимость()
	
	ФиксТариф = (Объект.МетодРасчета = ПредопределенноеЗначение("Перечисление.уатМетодыРасчетаПоТарифам.ФиксированнойСуммой"));
	ПроцТариф = (Объект.МетодРасчета = ПредопределенноеЗначение("Перечисление.уатМетодыРасчетаПоТарифам.ПроцентомОтСуммы"));
	
	// надпись с валютой
	Если ПроцТариф Тогда
		Элементы.ДекорацияТариф.Заголовок = "%";
		Элементы.ТарифыТариф.Заголовок = "Тариф, %";
		Элементы.ГруппаБазовыеУслуги.Видимость = Истина;
		Элементы.Тариф.ФорматРедактирования = "ЧЦ=5; ЧДЦ=2";
		Элементы.ГруппаПараметрВыработки.Видимость = Ложь;
		
		Если Объект.Скидка Тогда
			Элементы.Тариф.МаксимальноеЗначение = 100;
		Иначе
			Элементы.Тариф.МаксимальноеЗначение = 999;
		КонецЕсли;
		
		Элементы.ГруппаРасчет.ОтображатьЗаголовок = Истина;
		Элементы.ГруппаРасчетЛевая.ЦветФона = Новый Цвет(244, 244, 244);
		Элементы.ГруппаПодсказкаТарифПроцентом.Видимость = Истина;
		
	Иначе
		Если Объект.ПараметрВыработки = ПредопределенноеЗначение("Справочник.уатПараметрыВыработки.СтоимостьГруза") Тогда
			Элементы.ДекорацияТариф.Заголовок = "%";
			Элементы.ТарифыТариф.Заголовок = "Тариф, %";
		Иначе
			Элементы.ДекорацияТариф.Заголовок = Валюта;
			Элементы.ТарифыТариф.Заголовок = "Тариф, " + Валюта;
		КонецЕсли;
		
		Элементы.ГруппаБазовыеУслуги.Видимость = Ложь;
		Элементы.Тариф.ФорматРедактирования = "";
		
		Элементы.ГруппаПараметрВыработки.Видимость = Истина;
		Если ЗначениеЗаполнено(Объект.ПараметрВыработки) Тогда
			СформироватьНадписьПараметрВыработки();
		КонецЕсли;
		
		Элементы.ПараметрВыработки.АвтоОтметкаНезаполненного = НЕ (ФиксТариф И Объект.УсловиеПримененияФиксТарифа = 1);
		Элементы.ПараметрВыработки.ОтметкаНезаполненного = Элементы.ПараметрВыработки.АвтоОтметкаНезаполненного 
			И Не ЗначениеЗаполнено(Объект.ПараметрВыработки);
			
		Элементы.Тариф.МаксимальноеЗначение = Неопределено;
		Элементы.ГруппаРасчет.ОтображатьЗаголовок = Ложь;
		Элементы.ГруппаРасчетЛевая.ЦветФона = ЦветФонаФормы();
		Элементы.ГруппаПодсказкаТарифПроцентом.Видимость = Ложь;
		
	КонецЕсли;
	
	Элементы.ГруппаСтраницаОбластьДействия.Видимость = НЕ Объект.ТарифнаяСетка;
	Элементы.ТарифнаяСетка.Доступность = НЕ ПроцТариф;
	Элементы.ГруппаМинимальнаяВыработка.Видимость = (НЕ ПроцТариф) И (НЕ Объект.ТарифнаяСетка) И Объект.УсловиеПримененияФиксТарифа = 0 
		И (Не Объект.ПараметрВыработки = ПредопределенноеЗначение("Справочник.уатПараметрыВыработки.СкладскаяОбработка"));
	Элементы.ГруппаМинКоличество.Видимость = Элементы.ГруппаМинимальнаяВыработка.Видимость И (НЕ Объект.СложныйТариф) ИЛИ ФиксТариф;
	Элементы.ГруппаМинимальнаяСтоимость.Видимость = Элементы.ГруппаМинимальнаяВыработка.Видимость И (НЕ ФиксТариф);
	Элементы.СпособЗаполненияКоличества.Видимость = Элементы.ГруппаМинимальнаяВыработка.Видимость И (НЕ ФиксТариф);
		
	// Форматирование количества минимальной выработки для временных параметров выработки
	Если уатОбщегоНазначенияТиповые.ПолучитьЗначениеРеквизита(Объект.ПараметрВыработки, "Временный") Тогда
		Элементы.ГруппаМинВыработкаВременной.Видимость = Истина;
		Элементы.ГруппаМинВыработка.Видимость = Ложь;
	Иначе
		Элементы.ГруппаМинВыработкаВременной.Видимость = Ложь;
		Элементы.ГруппаМинВыработка.Видимость = Истина;
	КонецЕсли;
	
	Если Объект.СложныйТариф Тогда
		Элементы.ГруппаТариф.Видимость = Ложь;
		Элементы.ГруппаСтраницаТаблицаРасчета.Видимость = НЕ Объект.ТарифнаяСетка;
	Иначе
		Элементы.ГруппаТариф.Видимость = НЕ Объект.ТарифнаяСетка;
		Элементы.ГруппаСтраницаТаблицаРасчета.Видимость = Ложь;
	КонецЕсли;
	
	Элементы.ТипПункта.Видимость            = (Объект.ПараметрВыработки = ПредопределенноеЗначение("Справочник.уатПараметрыВыработки.КоличествоТочекПоТипуПункта")
		ИЛИ Объект.ПараметрВыработки = ПредопределенноеЗначение("Справочник.уатПараметрыВыработки.ПробегВнеГеозоныПоТипуПункта"));
	Элементы.ТипТочкиМаршрута.Видимость     = (Объект.ПараметрВыработки = ПредопределенноеЗначение("Справочник.уатПараметрыВыработки.КоличествоТочекПоВидуОперации")
		ИЛИ Объект.ПараметрВыработки = ПредопределенноеЗначение("Справочник.уатПараметрыВыработки.ПробегВнеГеозоныПоВидуОперации"));
	Элементы.ВидУпаковки.Видимость          = (Объект.ПараметрВыработки = ПредопределенноеЗначение("Справочник.уатПараметрыВыработки.КоличествоУпаковок"))
		ИЛИ (Объект.БазаТарифа = ПредопределенноеЗначение("Перечисление.уатБазыСкладскихТарифов_уэ.КоличествоМест"));
	Элементы.ТипКонтейнера.Видимость        = (Объект.ПараметрВыработки = ПредопределенноеЗначение("Справочник.уатПараметрыВыработки.КоличествоКонтейнеров")
		ИЛИ Объект.БазаТарифа = ПредопределенноеЗначение("Перечисление.уатБазыСкладскихТарифов_уэ.КоличествоКонтейнеров"));	
	Элементы.ВидСкладскойОперации.Видимость = (Объект.ПараметрВыработки = ПредопределенноеЗначение("Справочник.уатПараметрыВыработки.СкладскаяОбработка"));
	Элементы.БазаТарифа.Видимость           = (Объект.ПараметрВыработки = ПредопределенноеЗначение("Справочник.уатПараметрыВыработки.СкладскаяОбработка"))
		И (Объект.МетодРасчета = ПредопределенноеЗначение("Перечисление.уатМетодыРасчетаПоТарифам.ПоПараметруВыработки"));
	Элементы.НастроитьНормуБесплатногоХранения.Видимость = (Объект.ВидСкладскойОперации = ПредопределенноеЗначение("Перечисление.уатВидыСкладскихОпераций_уэ.Хранение"));
		
	Элементы.ГруппаКоличествоБесплатныхЕдиниц.Видимость =
		Объект.МетодРасчета = ПредопределенноеЗначение("Перечисление.уатМетодыРасчетаПоТарифам.ПоПараметруВыработки")
		И Объект.ВидСкладскойОперации <> ПредопределенноеЗначение("Перечисление.уатВидыСкладскихОпераций_уэ.Хранение")
		И Объект.ПараметрВыработки <> ПредопределенноеЗначение("Справочник.уатПараметрыВыработки.СтоимостьГруза");
	
	// настройка страницы "группировки"
	Если Элементы.ГруппаСтраницаТаблицаРасчета.Видимость Тогда
		Элементы.ТарифыГруппировка1.Видимость = ЗначениеЗаполнено(Объект.ГруппировкаТарифа1);
		Элементы.ТарифыГруппировка2.Видимость = ЗначениеЗаполнено(Объект.ГруппировкаТарифа2);
		Элементы.ТарифыГруппировка3.Видимость = ЗначениеЗаполнено(Объект.ГруппировкаТарифа3);
		Элементы.ТарифыГруппировка4.Видимость = ЗначениеЗаполнено(Объект.ГруппировкаТарифа4);
		
		Элементы.ТарифыГруппировка1.Заголовок = Объект.ГруппировкаТарифа1;
		Элементы.ТарифыГруппировка2.Заголовок = Объект.ГруппировкаТарифа2;
		Элементы.ТарифыГруппировка3.Заголовок = Объект.ГруппировкаТарифа3;
		Элементы.ТарифыГруппировка4.Заголовок = Объект.ГруппировкаТарифа4;
		
		Если ЗначениеЗаполнено(Объект.ГруппировкаТарифа1) Тогда
			Если Объект.ГруппировкаТарифа1 = ПредопределенноеЗначение("Перечисление.уатГруппировкиТарифов.КлассГруза") Тогда
				Элементы.ТарифыЗначениеГруппировки1.Формат = "ЧДЦ = 0; ЧЦ = 2";
				Элементы.ТарифыЗначениеГруппировки1.ФорматРедактирования = "ЧДЦ = 0; ЧЦ = 2";
			Иначе
				Элементы.ТарифыЗначениеГруппировки1.Формат = "ЧДЦ = 3; ЧЦ = 10";
				Элементы.ТарифыЗначениеГруппировки1.ФорматРедактирования = "ЧДЦ = 3; ЧЦ = 10";
			КонецЕсли;
		КонецЕсли;
		Если ЗначениеЗаполнено(Объект.ГруппировкаТарифа2) Тогда
			Если Объект.ГруппировкаТарифа2 = ПредопределенноеЗначение("Перечисление.уатГруппировкиТарифов.КлассГруза") Тогда
				Элементы.ТарифыЗначениеГруппировки2.Формат = "ЧДЦ = 0; ЧЦ = 2";
				Элементы.ТарифыЗначениеГруппировки2.ФорматРедактирования = "ЧДЦ = 0; ЧЦ = 2";
			Иначе
				Элементы.ТарифыЗначениеГруппировки2.Формат = "ЧДЦ = 3; ЧЦ = 10";
				Элементы.ТарифыЗначениеГруппировки2.ФорматРедактирования = "ЧДЦ = 3; ЧЦ = 10";
			КонецЕсли;
		КонецЕсли;
		Если ЗначениеЗаполнено(Объект.ГруппировкаТарифа3) Тогда
			Если Объект.ГруппировкаТарифа3 = ПредопределенноеЗначение("Перечисление.уатГруппировкиТарифов.КлассГруза") Тогда
				Элементы.ТарифыЗначениеГруппировки3.Формат = "ЧДЦ = 0; ЧЦ = 2";
				Элементы.ТарифыЗначениеГруппировки3.ФорматРедактирования = "ЧДЦ = 0; ЧЦ = 2";
			Иначе
				Элементы.ТарифыЗначениеГруппировки3.Формат = "ЧДЦ = 3; ЧЦ = 10";
				Элементы.ТарифыЗначениеГруппировки3.ФорматРедактирования = "ЧДЦ = 3; ЧЦ = 10";
			КонецЕсли;
		КонецЕсли;
		Если ЗначениеЗаполнено(Объект.ГруппировкаТарифа4) Тогда
			Если Объект.ГруппировкаТарифа4 = ПредопределенноеЗначение("Перечисление.уатГруппировкиТарифов.КлассГруза") Тогда
				Элементы.ТарифыЗначениеГруппировки4.Формат = "ЧДЦ = 0; ЧЦ = 2";
				Элементы.ТарифыЗначениеГруппировки4.ФорматРедактирования = "ЧДЦ = 0; ЧЦ = 2";
			Иначе
				Элементы.ТарифыЗначениеГруппировки4.Формат = "ЧДЦ = 3; ЧЦ = 10";
				Элементы.ТарифыЗначениеГруппировки4.ФорматРедактирования = "ЧДЦ = 3; ЧЦ = 10";
			КонецЕсли;
		КонецЕсли;
	КонецЕсли;
	
	Элементы.УсловиеПримененияФиксТарифа.Видимость = ФиксТариф;
	Если ФиксТариф Тогда
		ТекстНСТР = НСтр("en='The tariff will be used in calculating the cost of services if the amount of output in the document is not less than the specified value.';ru='Тариф будет использоваться при расчете стоимости услуг, если количество выработки в документе не меньше, чем указанное значение.'");
	Иначе
		ТекстНСТР = НСтр("en='The minimum amount of output for the specified output parameter, which is taken into account when calculating the cost of services at tariffs. If the amount of output is less than the minimum, the price of the service will be recalculated at the minimum cost according to the tariff.';ru='Минимальное количество выработки по указанному параметру выработки, которое учитывается при расчете стоимости услуг по тарифам. Если количество выработки меньше чем минимальное, то цена услуги будет пересчитана по минимальной стоимости по тарифу.'");
	КонецЕсли;
	Элементы.МинимальнаяВыработка.Подсказка = ТекстНСТР;
	Элементы.МинВыработкаВременной.Подсказка = ТекстНСТР;
	
	Если НЕ уатОбщегоНазначенияПовтИсп.ВариантПоставкиКОРП() Тогда
		Элементы.тРекомендацияГеозоны.Видимость = Ложь;
		Элементы.тРекомендацияГеозоныСсылка.Видимость = Ложь;
	КонецЕсли;
	
	Элементы.ГруппаСкидкаНаценка.Видимость = ПроцТариф;
	Элементы.ДобавлятьСкидкуНаценкуОтдельнойСтрокой.Видимость = ПроцТариф И (НЕ Объект.Скидка);
	Элементы.ГруппаСкидкаНаценкаПервыеЗаказы.Видимость = ПроцТариф
		И уатОбщегоНазначенияТиповые.ПолучитьЗначениеРеквизита(Объект.Владелец, "ПрейскурантПоставщика") = Ложь;
	
КонецПроцедуры

&НаКлиенте
Процедура СформироватьНадписьПараметрВыработки()
	Если НЕ ЗначениеЗаполнено(Объект.ПараметрВыработки) Тогда
		ДокументыПараметраВыработки = "";
		Возврат;
	КонецЕсли;
	
	СтруктураРеквизитовПараметраВыработки = СтруктураРеквизитовПараметраВыработки(Объект.ПараметрВыработки);
	
	Если НЕ СтруктураРеквизитовПараметраВыработки.ИспользоватьВТарифахНаУслуги
		И НЕ СтруктураРеквизитовПараметраВыработки.ИспользоватьДляЗаказовИПотребности
		И НЕ СтруктураРеквизитовПараметраВыработки.ИспользоватьДляМаршрутныхЛистов Тогда
		ДокументыПараметраВыработки = НСтр("en='Tariff not used to calculate service!';ru='Тариф не используется для расчета услуг!'");
	Иначе
		ДокументыПараметраВыработки =  НСтр("en='Rate used for documents:';ru='Тариф используется для документов:'") + " ";
		Если СтруктураРеквизитовПараметраВыработки.ИспользоватьДляЗаказовИПотребности Тогда
			ДокументыПараметраВыработки = ДокументыПараметраВыработки + """Заказ на ТС"", ""Заказ перевозчику"" (по заказам на ТС), ""Потребность в Перевозке"", ";
			Если Объект.ПараметрВыработки = ПредопределенноеЗначение("Справочник.уатПараметрыВыработки.СтоимостьГруза") Тогда
				ДокументыПараметраВыработки = ДокументыПараметраВыработки + """Страховой сертификат"", ";
			КонецЕсли;
		КонецЕсли;
		Если СтруктураРеквизитовПараметраВыработки.ИспользоватьДляМаршрутныхЛистов Тогда
			ДокументыПараметраВыработки = ДокументыПараметраВыработки + НСтр("en='""Routing list""';ru='""Маршрутный лист"", ""Заказ перевозчику"" (по маршрутным листам)'") + ", ";
		КонецЕсли;
		Если СтруктураРеквизитовПараметраВыработки.ИспользоватьВТарифахНаУслуги Тогда
			ДокументыПараметраВыработки = ДокументыПараметраВыработки + НСтр("en='""Goods shipping documents""';ru='""ТТД""'") + ", ";
		КонецЕсли;
		ДокументыПараметраВыработки = Лев(ДокументыПараметраВыработки, СтрДлина(ДокументыПараметраВыработки)-2);
	КонецЕсли;
	
	Элементы.ПараметрВыработки.Подсказка = ДокументыПараметраВыработки;
КонецПроцедуры

&НаКлиенте
Процедура СформироватьНадписьЕИ()
	//Если Объект.ПараметрВыработки.Пустая() Тогда
	//	Элементы.ДекорацияБесплат.Заголовок = "";
	//	Элементы.ДекорацияМинВыработка.Заголовок = "";
	//	Элементы.ДекорацияМинВыработка2.Заголовок = "";
	//Иначе
	//	ЕИПараметраВыработки = уатОбщегоНазначенияТиповые.ПолучитьЗначениеРеквизита(Объект.ПараметрВыработки, "ЕдиницаИзмерения");
	//	Элементы.ДекорацияБесплат.Заголовок = ЕИПараметраВыработки;
	//	Элементы.ДекорацияМинВыработка.Заголовок = ЕИПараметраВыработки;
	//	Элементы.ДекорацияМинВыработка2.Заголовок = ЕИПараметраВыработки;
	//КонецЕсли;
КонецПроцедуры

&НаСервереБезКонтекста
Функция СтруктураРеквизитовПараметраВыработки(ПарамВыраб)
	Возврат уатОбщегоНазначенияТиповыеСервер.ПолучитьЗначенияРеквизитов(ПарамВыраб,
		"ИспользоватьВТарифахНаУслуги, ИспользоватьДляЗаказовИПотребности, ИспользоватьДляМаршрутныхЛистов");
КонецФункции

&НаКлиенте
Процедура ПеречитатьОбъект(РезультатЗакрытия, ДополнительныеПараметры) Экспорт
	
	Прочитать();
	
КонецПроцедуры

&НаКлиенте
Процедура ВыборГруппировкиТарифаОткрытьФорму(Элемент)
	
	ДополнительныеПараметры = Новый Структура("Элемент", Элемент);
	ОповещениеОЗакрытии = Новый ОписаниеОповещения("ВыборГруппировкиТарифаЗавершение", ЭтаФорма, ДополнительныеПараметры);
	
	ПараметрыФормы = Новый Структура;
	списГруппировки = Новый СписокЗначений;
	списГруппировки.Добавить(ПредопределенноеЗначение("Перечисление.уатГруппировкиТарифов.Грузоподъемность"));
	списГруппировки.Добавить(ПредопределенноеЗначение("Перечисление.уатГруппировкиТарифов.ОбъемКузова"));
	списГруппировки.Добавить(ПредопределенноеЗначение("Перечисление.уатГруппировкиТарифов.КлассГруза"));
	списГруппировки.Добавить(ПредопределенноеЗначение("Перечисление.уатГруппировкиТарифов.СтоимостьГруза"));

	ПараметрыФормы.Вставить("ДополнительныеГруппировки", списГруппировки);
	
	ОткрытьФорму("Справочник.уатТарифыТС.Форма.ФормаВыбораГруппировкиТарифа", ПараметрыФормы,ЭтаФорма,,,,ОповещениеОЗакрытии,РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
	
КонецПроцедуры

&НаКлиенте
Процедура ВыборГруппировкиТарифаЗавершение(Результат, ДополнительныеПараметры) Экспорт
	
	Если Не ЗначениеЗаполнено(Результат) Тогда
		Возврат;
	КонецЕсли;
	
	Если ДополнительныеПараметры.Элемент = Элементы.ГруппировкаТарифа1 Тогда
		Объект.ГруппировкаТарифа1 = Результат;
	ИначеЕсли ДополнительныеПараметры.Элемент = Элементы.ГруппировкаТарифа2 Тогда
		Объект.ГруппировкаТарифа2 = Результат;
	ИначеЕсли ДополнительныеПараметры.Элемент = Элементы.ГруппировкаТарифа3 Тогда
		Объект.ГруппировкаТарифа3 = Результат;
	ИначеЕсли ДополнительныеПараметры.Элемент = Элементы.ГруппировкаТарифа4 Тогда
		Объект.ГруппировкаТарифа4 = Результат;
	КонецЕсли;
	Модифицированность = Истина;
	УстановитьВидимость();
	
КонецПроцедуры

&НаСервере
Процедура УстановитьОтборПараметраВыработки()
	Запрос = Новый Запрос(
	"ВЫБРАТЬ
	|	уатПараметрыВыработки.Ссылка КАК Ссылка
	|ИЗ
	|	Справочник.уатПараметрыВыработки КАК уатПараметрыВыработки
	|ГДЕ
	|	(уатПараметрыВыработки.ИспользоватьВТарифахНаУслуги
	|			ИЛИ уатПараметрыВыработки.ИспользоватьДляЗаказовИПотребности
	|			ИЛИ уатПараметрыВыработки.ИспользоватьДляМаршрутныхЛистов)");
	мсвПараметрыВыработки = Запрос.Выполнить().Выгрузить().ВыгрузитьКолонку("Ссылка");
	мсвПараметрыВыбора = Новый Массив;
	мсвПараметрыВыбора.Добавить(Новый ПараметрВыбора("Отбор.Ссылка", мсвПараметрыВыработки));
	Элементы.ПараметрВыработки.ПараметрыВыбора = Новый ФиксированныйМассив(мсвПараметрыВыбора);
КонецПроцедуры

&НаСервереБезКонтекста
Функция ЦветФонаФормы()
	Возврат ЦветаСтиля.ЦветФонаФормы;
КонецФункции

#КонецОбласти
