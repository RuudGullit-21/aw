
#Область ОбработчикиСобытийФормы

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	Ответственный = ПользователиКлиентСервер.АвторизованныйПользователь();
	Организация = уатОбщегоНазначенияПовтИсп.ПолучитьЗначениеПоУмолчаниюПользователя(
		Ответственный, "ОсновнаяОрганизация");
	СтруктураОбъектовНастроек = Новый Структура("Организация", Организация);
	ОтборМестоположение = уатПраваИНастройки.уатПолучитьПраваИНастройкиПользователя(
		СтруктураОбъектовНастроек, "ОсновнойПунктОтправления");
	
	Если НЕ ЗначениеЗаполнено(ОтборСтатус) Тогда
		ОтборСтатус = ПредопределенноеЗначение("Справочник.уатСтатусы_уэ.Новый");
	КонецЕсли;
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ПодобратьСД(Команда)
	Если Не ЗначениеЗаполнено(ОтборСтатус) Тогда
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю("Не указано значение отбора по статусу",, "ОтборСтатус");
		Возврат;
	КонецЕсли;
	Если Не ЗначениеЗаполнено(ОтборМестоположение) Тогда
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю("Не указано значение отбора по местоположению",, "ОтборМестоположение");
		Возврат;
	КонецЕсли;
	
	ПодобратьДокументыСервер();
КонецПроцедуры

&НаКлиенте
Процедура СоздатьПакеты(Команда)
	мсвСозданныеПакеты = Неопределено;
	СоздатьПакетыСервер(мсвСозданныеПакеты);
	
	Для Каждого ТекПакет Из мсвСозданныеПакеты Цикл
		ПоказатьЗначение(Неопределено, ТекПакет);
	КонецЦикла;
КонецПроцедуры

&НаКлиенте
Процедура УстановитьВсе(Команда)
	Для Каждого ТекСтрока Из ПакетыДокументов Цикл
		ТекСтрока.Пометка = Истина;
	КонецЦикла;
КонецПроцедуры

&НаКлиенте
Процедура СнятьВсе(Команда)
	Для Каждого ТекСтрока Из ПакетыДокументов Цикл
		ТекСтрока.Пометка = Ложь;
	КонецЦикла;
КонецПроцедуры

#КонецОбласти

#Область СлужеюныеПроцедурыИФункции

&НаКлиенте
Процедура ПакетыДокументовВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	Если Поле.Имя = "ПакетыДокументовПакет" Тогда
		ТекПакет = Элементы.ПакетыДокументов.ТекущиеДанные.Пакет;
		Если ЗначениеЗаполнено(ТекПакет) Тогда
			ПоказатьЗначение(Неопределено, ТекПакет);
		КонецЕсли;
	КонецЕсли;
КонецПроцедуры


&НаСервере
Процедура ПодобратьДокументыСервер()
	СопроводительныеДокументы.Очистить();
	ПакетыДокументов.Очистить();
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	уатСопроводительныеДокументыСрезПоследних.СопроводительныйДокумент,
	|	уатСопроводительныеДокументыСрезПоследних.СопроводительныйДокумент.ВладелецДокумента КАК ВладелецДокумента,
	|	уатСопроводительныеДокументыСрезПоследних.Организация,
	|	уатСопроводительныеДокументыСрезПоследних.Отправитель,
	|	уатСопроводительныеДокументыСрезПоследних.ПунктОтправления,
	|	уатСопроводительныеДокументыСрезПоследних.Получатель,
	|	уатСопроводительныеДокументыСрезПоследних.ПунктПрибытия,
	|	1 КАК Количество
	|ИЗ
	|	РегистрСведений.уатСтатусыСопроводительныхДокументов.СрезПоследних КАК уатСопроводительныеДокументыСрезПоследних
	|ГДЕ
	|	уатСопроводительныеДокументыСрезПоследних.Местоположение = &Местоположение
	|	И уатСопроводительныеДокументыСрезПоследних.Статус = &Статус";
	Запрос.УстановитьПараметр("Местоположение", ОтборМестоположение);
	Запрос.УстановитьПараметр("Статус", ОтборСтатус);
	тблСД = Запрос.Выполнить().Выгрузить();
	
	Для Каждого ТекСтрока Из тблСД Цикл
		НоваяСтрока = СопроводительныеДокументы.Добавить();
		ЗаполнитьЗначенияСвойств(НоваяСтрока, ТекСтрока);
	КонецЦикла;
	
	тблСДсвернутая = тблСД.Скопировать();
	тблСДсвернутая.Свернуть("ВладелецДокумента, Организация", "Количество");
	
	Для Каждого ТекСтрока Из тблСДсвернутая Цикл
		НоваяСтрока = ПакетыДокументов.Добавить();
		ЗаполнитьЗначенияСвойств(НоваяСтрока, ТекСтрока);
	КонецЦикла;
КонецПроцедуры

&НаСервере
Процедура СоздатьПакетыСервер(мсвСозданныеПакеты = Неопределено)
	мсвСозданныеПакеты = Новый Массив;
	
	Для Каждого ТекСтрока Из ПакетыДокументов Цикл
		Если НЕ ТекСтрока.Пометка Тогда
			Продолжить;
		КонецЕсли;
		Если ЗначениеЗаполнено(ТекСтрока.Пакет) Тогда
			ТекСтрока.Пометка = Ложь;
			Продолжить;
		КонецЕсли;
			
		СтруктураПоиска = Новый Структура("ВладелецДокумента, Организация", ТекСтрока.ВладелецДокумента, ТекСтрока.Организация);
		мсвСтрокиПоиска = СопроводительныеДокументы.НайтиСтроки(СтруктураПоиска);
		Если мсвСтрокиПоиска.Количество() = 0 Тогда
			Продолжить;
		КонецЕсли;
		
		НовыйПакет = Документы.уатПакетСопроводительныхДокументов.СоздатьДокумент();
		НовыйПакет.Дата = ТекущаяДата();
		НовыйПакет.УстановитьНовыйНомер();
		НовыйПакет.Организация = ТекСтрока.Организация;
		НовыйПакет.Отправлен = Истина;
		НовыйПакет.ДатаОтправления = НовыйПакет.Дата;
		НовыйПакет.ПунктОтправления = ОтборМестоположение;
		НовыйПакет.СтатусОтправления = СтатусОтправления;
		НовыйПакет.Ответственный = Ответственный;
		НовыйПакет.ОтветственныйЗаОтправку = Ответственный;
		НовыйПакет.Отправитель = Отправитель;
		НовыйПакет.Получатель = ТекСтрока.ВладелецДокумента;
		
		Для Каждого ТекДок Из мсвСтрокиПоиска Цикл
			НоваяСтрока = НовыйПакет.СопроводительныеДокументы.Добавить();
			НоваяСтрока.СопроводительныйДокумент = ТекДок.СопроводительныйДокумент;
		КонецЦикла;
		
		НовыйПакет.ОбменДанными.Загрузка = Истина;
		Попытка
			НовыйПакет.Записать(РежимЗаписиДокумента.Запись);
			ТекСтрока.Пакет = НовыйПакет.Ссылка;
			ТекСтрока.Пометка = Ложь;
			мсвСозданныеПакеты.Добавить(НовыйПакет.Ссылка);
		Исключение
			ТекстОшибки = СтрШаблон("Не удалось записать документ %1: %2", НовыйПакет, ИнформацияОбОшибке().Описание);
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстОшибки);
		КонецПопытки;
	КонецЦикла;
КонецПроцедуры

#КонецОбласти