
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	уатЗащищенныеФункцииСервер.уатДокументФормаСпискаПриСозданииНаСервере(Отказ, СтандартнаяОбработка, ЭтотОбъект, ДопПараметрыОткрытие);
	Если Отказ тогда
		Возврат;
	КонецЕсли;
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКоманды.ПриСозданииНаСервере(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
	// СтандартныеПодсистемы.ВерсионированиеОбъектов
    ВерсионированиеОбъектов.ПриСозданииНаСервере(ЭтотОбъект);
    // Конец СтандартныеПодсистемы.ВерсионированиеОбъектов
	
	ТекОрг = уатОбщегоНазначенияПовтИсп.ПолучитьЗначениеПоУмолчаниюПользователя(ПользователиКлиентСервер.АвторизованныйПользователь(), "ОсновнаяОрганизация");
	ОбщегоНазначенияКлиентСервер.УстановитьПараметрДинамическогоСписка(Список, "ТекОрг", ТекОрг);
	
	Если ПолучитьФункциональнуюОпцию("уатИспользоватьСервисШтрафовНет") = ЛОЖЬ Тогда
		Элементы.ЗагрузкаДанных.Видимость = Ложь;
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	уатЗащищенныеФункцииКлиент.уатДокументФормаСпискаПриОткрытии(Отказ, ЭтотОбъект, ДопПараметрыОткрытие);
	Если Отказ Тогда
		Возврат;
	КонецЕсли;
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормы_Список

&НаКлиенте
Процедура СписокПриАктивизацииСтроки(Элемент)
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиент.НачатьОбновлениеКоманд(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

// СтандартныеПодсистемы.ПодключаемыеКоманды
&НаКлиенте
Процедура Подключаемый_ВыполнитьКоманду(Команда)
	ПодключаемыеКомандыКлиент.НачатьВыполнениеКоманды(ЭтотОбъект, Команда, Элементы.Список);
КонецПроцедуры
// Конец СтандартныеПодсистемы.ПодключаемыеКоманды

&НаКлиенте
Процедура ОбновитьДанные(Команда)
	
	СписокЭлемент    = Элементы.Список;
	ВыделенныеСтроки = СписокЭлемент.ВыделенныеСтроки;
	
	Для Каждого ВыделеннаяСтрока Из ВыделенныеСтроки Цикл
		Если ТипЗнч(ВыделеннаяСтрока) = Тип("СтрокаГруппировкиДинамическогоСписка") Тогда
			Продолжить;
		КонецЕсли;
		ТекущаяСтрока = СписокЭлемент.ДанныеСтроки(ВыделеннаяСтрока);
		Если ТекущаяСтрока <> Неопределено Тогда
			Если ТекущаяСтрока.ПометкаУдаления Тогда
				ТекстНСТР = СтрШаблон(НСтр("ru='Помеченный на удаление документ %1 не может быть обновлен!'"), ТекущаяСтрока.Ссылка);
				ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстНСТР);
				Продолжить;
			КонецЕсли;

			ОбновитьДанныеСервер(ТекущаяСтрока.Ссылка);
		КонецЕсли;
	КонецЦикла;
	Элементы.Список.Обновить();
	
	Нстр = НСтр("ru='Обновление завершено'");
	ПоказатьПредупреждение(Неопределено, Нстр);
		
КонецПроцедуры

&НаКлиенте
Процедура ЗагрузитьФото(Команда)
	
	СписокЭлемент    = Элементы.Список;
	ВыделенныеСтроки = СписокЭлемент.ВыделенныеСтроки;
	
	Для Каждого ВыделеннаяСтрока Из ВыделенныеСтроки Цикл
		Если ТипЗнч(ВыделеннаяСтрока) = Тип("СтрокаГруппировкиДинамическогоСписка") Тогда
			Продолжить;
		КонецЕсли;
		ТекущаяСтрока = СписокЭлемент.ДанныеСтроки(ВыделеннаяСтрока);
		Если ТекущаяСтрока <> Неопределено Тогда
			Если ТекущаяСтрока.ПометкаУдаления Тогда
				ТекстНСТР = СтрШаблон(НСтр("ru='Помеченный на удаление документ %1 не может быть обновлен!'"), ТекущаяСтрока.Ссылка);
				ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстНСТР);
				Продолжить;
			КонецЕсли;
			ОбновитьДанныеСервер(ТекущаяСтрока.Ссылка, Истина);
		КонецЕсли;
	КонецЦикла;
	Элементы.Список.Обновить();
	
	Нстр = НСтр("ru='Загрузка фото завершена'");
	ПоказатьПредупреждение(Неопределено, Нстр);

КонецПроцедуры

&НаКлиенте
Процедура ЗагрузитьКарточкуШтрафа(Команда)
	
	СписокЭлемент    = Элементы.Список;
	ВыделенныеСтроки = СписокЭлемент.ВыделенныеСтроки;
	
	Для Каждого ВыделеннаяСтрока Из ВыделенныеСтроки Цикл
		Если ТипЗнч(ВыделеннаяСтрока) = Тип("СтрокаГруппировкиДинамическогоСписка") Тогда
			Продолжить;
		КонецЕсли;
		ТекущаяСтрока = СписокЭлемент.ДанныеСтроки(ВыделеннаяСтрока);
		Если ТекущаяСтрока <> Неопределено Тогда
			Если ТекущаяСтрока.ПометкаУдаления Тогда
				ТекстНСТР = СтрШаблон(НСтр("ru='Помеченный на удаление документ %1 не может быть обновлен!'"), ТекущаяСтрока.Ссылка);
				ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстНСТР);
				Продолжить;
			КонецЕсли;
			ОбновитьДанныеСервер(ТекущаяСтрока.Ссылка,, Истина);
		КонецЕсли;
	КонецЦикла;
	Элементы.Список.Обновить();

	Нстр = НСтр("ru='Загрузка карточки штрафа завершена'");
	ПоказатьПредупреждение(Неопределено, Нстр);
	
КонецПроцедуры

&НаКлиенте
Процедура ИзменитьВыделенные(Команда)
	
	ГрупповоеИзменениеОбъектовКлиент.ИзменитьВыделенные(Элементы.Список, Список);
	
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
    ПодключаемыеКоманды.ВыполнитьКоманду(ЭтотОбъект, ПараметрыВыполнения, Элементы.Список);
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ОбновитьКоманды()
    ПодключаемыеКомандыКлиентСервер.ОбновитьКоманды(ЭтотОбъект, Элементы.Список);
КонецПроцедуры
// Конец СтандартныеПодсистемы.ПодключаемыеКоманды

&НаСервереБезКонтекста
Процедура ОбновитьДанныеСервер(Объект, ЗагрузкаФото = Ложь, ЗагрузкаКарточкиШтрафа = Ложь, КарточкаШтрафа = Неопределено)
	
	Если ЗначениеЗаполнено(Объект.УчетнаяЗапись) Тогда
		УчетныеЗаписиСервисаШтрафов = Объект.УчетнаяЗапись;
	Иначе
		УчетныеЗаписиСервисаШтрафов = Объект.ТС.УчетнаяЗаписьCервисаШтрафов;
	КонецЕсли;
	
	Если НЕ ЗначениеЗаполнено(УчетныеЗаписиСервисаШтрафов) 
		И ЗначениеЗаполнено(Объект.Ссылка) Тогда
		Возврат;
	КонецЕсли;
	
	ИдентификаторШтрафа      = Объект.НомерПостановления;
	
	Если НЕ ЗначениеЗаполнено(ИдентификаторШтрафа) Тогда
		Возврат;
	КонецЕсли;
	
	МассивТС = Новый Массив();
	МассивТС.Добавить(Объект.ТС.ИДвСервисеШтрафов);
	
	ТекстОшибки = "";
	уатИнтеграции_проф.ШтрафовНет_ОбновитьШтраф(МассивТС, УчетныеЗаписиСервисаШтрафов,
		ИдентификаторШтрафа, ЗагрузкаФото, ЗагрузкаКарточкиШтрафа, ТекстОшибки);
	Если ЗначениеЗаполнено(ТекстОшибки) Тогда
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстОшибки);
		Возврат;
	КонецЕсли;
		
	Если ЗагрузкаКарточкиШтрафа Тогда
		МассивФайлов = РаботаСФайламиСлужебный.ПолучитьВсеПодчиненныеФайлы(Объект.Ссылка);
		Для Каждого ТекСтрока Из МассивФайлов Цикл
			Если ТекСтрока.Наименование = "Карточка штрафа.pdf" 
				И НЕ ТекСтрока.ПометкаУдаления Тогда
				КарточкаШтрафа = ТекСтрока;
				Прервать;
			КонецЕсли;
		КонецЦикла;
	КонецЕсли;

КонецПроцедуры

#КонецОбласти
