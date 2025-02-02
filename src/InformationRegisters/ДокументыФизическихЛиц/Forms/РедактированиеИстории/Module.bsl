
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Параметры.Свойство("ВедущийОбъект", ОбъектВладелец);
	Если Не ЗначениеЗаполнено(ОбъектВладелец) Тогда
		Отказ = Истина;
		Возврат;
	КонецЕсли;
	
	// Если объект еще не заблокирован для изменений и есть права на изменение набора
	// попытаемся установить блокировку
	//Если НЕ Пользователи.РолиДоступны("уатДобавлениеИзменениеНСИПерсонала") Тогда
	
	// В версии Стандарт нет ролей-функций, поэтому проверяется право доступа.
	Если Не ПравоДоступа("Изменение", Метаданные.РегистрыСведений.ДокументыФизическихЛиц) Тогда
		
		Элементы.ГруппаИнформационная.Видимость = Ложь;
		ТолькоПросмотр = Истина;
		
	КонецЕсли; 
	
	Если ТолькоПросмотр Тогда
		
		Элементы.НаборЗаписей.ТолькоПросмотр = Истина;
		
		ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(
			Элементы, 
			"ФормаКомандаОК",
			"Доступность",
			Ложь);
			
		Элементы.ФормаКомандаОтмена.КнопкаПоУмолчанию = Истина;
		
	Иначе
		Элементы.ГруппаИнформационная.Видимость = Ложь;
	КонецЕсли;
		
	Для Каждого ЗаписьНабора Из Параметры.МассивЗаписей Цикл
		ЗаполнитьЗначенияСвойств(НаборЗаписей.Добавить(), ЗаписьНабора);
	КонецЦикла;
	
	НаборЗаписей.Сортировать("Период,ЯвляетсяДокументомУдостоверяющимЛичность");
	
	Элементы.НаборЗаписей.ОтборСтрок = Новый ФиксированнаяСтруктура(Новый Структура(
		"ЯвляетсяДокументомУдостоверяющимЛичность", Истина));
	
КонецПроцедуры

#КонецОбласти


#Область ОбработчикиСобытийЭлементовТаблицыФормы

&НаКлиенте
Процедура НаборЗаписейПриНачалеРедактирования(Элемент, НоваяСтрока, Копирование)
	Если НоваяСтрока Тогда
		Если Элемент.ТекущиеДанные <> Неопределено Тогда
			Элемент.ТекущиеДанные.ФизЛицо = ОбъектВладелец;
			НовыйПериод = НачалоДня(ОбщегоНазначенияКлиент.ДатаСеанса());
			Если НаборЗаписей.Количество() > 1 Тогда
				ПоследнийПериод = НаборЗаписей.Получить(НаборЗаписей.Количество() - 2).Период;
			Иначе
				ПоследнийПериод = '00010101000000';
			КонецЕсли; 
			Если НовыйПериод <= ПоследнийПериод Тогда
				НовыйПериод = КонецДня(ПоследнийПериод) + 1;
			КонецЕсли;
			Элемент.ТекущиеДанные.Период = НовыйПериод;
			Элемент.ТекущиеДанные.ВидДокумента = ПредопределенноеЗначение("Справочник.ВидыДокументовФизическихЛиц.ПаспортРФ");
			Элемент.ТекущиеДанные.ЯвляетсяДокументомУдостоверяющимЛичность = Истина;
		КонецЕсли;
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура НаборЗаписейПередОкончаниемРедактирования(Элемент, НоваяСтрока, ОтменаРедактирования, Отказ)
	Если НЕ ОтменаРедактирования Тогда
		Если Элемент.ТекущиеДанные <> Неопределено Тогда
			ИндексТекущейСтроки = НаборЗаписей.Индекс(Элемент.ТекущиеДанные);
			Если НЕ ЗначениеЗаполнено(Элемент.ТекущиеДанные.Период) Тогда
				СообщениеОбОшибке = НСтр("en='Enter information date';ru='Необходимо указать дату сведений'");
				ОбщегоНазначенияКлиентСервер.СообщитьПользователю(СообщениеОбОшибке,,"НаборЗаписей[" + ИндексТекущейСтроки + 
					"].Период", , Отказ);
			ИначеЕсли НЕ ЗначениеЗаполнено(Элемент.ТекущиеДанные.ВидДокумента) Тогда
				СообщениеОбОшибке = НСтр("en='Specify a document kind';ru='Необходимо указать вид документа'");
				ОбщегоНазначенияКлиентСервер.СообщитьПользователю(СообщениеОбОшибке,,"НаборЗаписей[" + ИндексТекущейСтроки + 
					"].ВидДокумента", , Отказ);
			Иначе
				НайденныеСтроки = НаборЗаписей.НайтиСтроки(Новый Структура("Период,ЯвляетсяДокументомУдостоверяющимЛичность", 
					Элемент.ТекущиеДанные.Период, Истина));
				Для Каждого НайденнаяСтрока Из НайденныеСтроки Цикл
					Если НайденнаяСтрока <> Элемент.ТекущиеДанные Тогда
						СообщениеОбОшибке = НСтр("en='Record on the identity document with the specified information date already exists';ru='Уже есть запись о документе, являющемся удостоверении личности с указанной датой сведений'");
						ОбщегоНазначенияКлиентСервер.СообщитьПользователю(СообщениеОбОшибке,,"НаборЗаписей[" + ИндексТекущейСтроки + "].Период", , Отказ);
						Прервать;
					КонецЕсли; 
				КонецЦикла;
			КонецЕсли; 
		КонецЕсли;
	КонецЕсли; 
КонецПроцедуры

&НаКлиенте
Процедура НаборЗаписейПриОкончанииРедактирования(Элемент, НоваяСтрока, ОтменаРедактирования)
	Элементы.НаборЗаписей.ОтборСтрок = Неопределено;
	НаборЗаписей.Сортировать("Период,ЯвляетсяДокументомУдостоверяющимЛичность");
	Элементы.НаборЗаписей.ОтборСтрок = Новый ФиксированнаяСтруктура(Новый Структура(
		"ЯвляетсяДокументомУдостоверяющимЛичность", Истина));
КонецПроцедуры

&НаКлиенте
Процедура НаборЗаписейДатаВыдачиПриИзменении(Элемент)
	ИдентификаторТекущейСтроки = Элементы.НаборЗаписей.ТекущаяСтрока;
	Если ИдентификаторТекущейСтроки <> Неопределено Тогда
		ТекущаяСтрока = НаборЗаписей.НайтиПоИдентификатору(ИдентификаторТекущейСтроки);
		Если ТекущаяСтрока <> Неопределено Тогда
			Если Не ЗначениеЗаполнено(ТекущаяСтрока.Период) и ЗначениеЗаполнено(ТекущаяСтрока.ДатаВыдачи) Тогда
				ТекущаяСтрока.Период = ТекущаяСтрока.ДатаВыдачи;
			КонецЕсли; 
		КонецЕсли; 
	КонецЕсли; 
КонецПроцедуры

#КонецОбласти


#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура КомандаОК(Команда)
	РедактированиеПериодическихСведенийКлиент.ОповеститьОЗавершении(ЭтаФорма, "ДокументыФизическихЛиц", ОбъектВладелец);
КонецПроцедуры

&НаКлиенте
Процедура КомандаОтмена(Команда)
	Закрыть();
КонецПроцедуры

#КонецОбласти
