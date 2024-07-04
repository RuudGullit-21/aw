#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	НаличиеСпидометра = Параметры.НаличиеСпидометра;
	
	Если НаличиеСпидометра Тогда
		ЛинейнаяНормаСтрока = "На пробег (линейная)";
	Иначе
		ЛинейнаяНормаСтрока = "Спец. на моточас";
	КонецЕсли;
	
	ШаблоныФормул.Добавить(ЛинейнаяНормаСтрока + " + На простой с вкл.двиг. + На ездки + На запуск", "Легковые автомобили");
	ШаблоныФормул.Добавить(ЛинейнаяНормаСтрока + " + На простой с вкл.двиг. + На отопитель + На ездки + На запуск", "Автобусы");
	ШаблоныФормул.Добавить(ЛинейнаяНормаСтрока + " + На транспортную работу + На изменение веса + На отопитель + На простой с вкл.двиг. + На ездки + На запуск + На операции", "Грузовые автомобили");
	ШаблоныФормул.Добавить(ЛинейнаяНормаСтрока + " + На транспортную работу + На отопитель + На простой с вкл.двиг. + На ездки + На запуск + На операции", "Самосвалы");
	ШаблоныФормул.Добавить(ЛинейнаяНормаСтрока + " + На транспортную работу + На изменение веса + На отопитель + На простой с вкл.двиг. + На ездки + На запуск + На операции + На спец.работу 1", "Специальные автомобили");
КонецПроцедуры

#КонецОбласти


#Область ОбработчикиСобытийЭлементовТаблицыФормы

&НаКлиенте
Процедура ШаблоныФормулВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	СтандартнаяОбработка = Ложь;
	ВыбратьШаблон();
КонецПроцедуры

&НаКлиенте
Процедура ШаблоныФормулПриАктивизацииСтроки(Элемент)
	ТекСтрока = Элементы.ШаблоныФормул.ТекущиеДанные;
	Если ТекСтрока.Представление = "Легковые автомобили" Тогда
		Описание = ПолучитьОписаниеИзМакета("ОписаниеШаблонЛегковые");
	ИначеЕсли ТекСтрока.Представление = "Автобусы" Тогда
		Описание = ПолучитьОписаниеИзМакета("ОписаниеШаблонАвтобусы");
	ИначеЕсли ТекСтрока.Представление = "Грузовые автомобили" Тогда
		Описание = ПолучитьОписаниеИзМакета("ОписаниеШаблонГрузовые");
	ИначеЕсли ТекСтрока.Представление = "Самосвалы" Тогда
		Описание = ПолучитьОписаниеИзМакета("ОписаниеШаблонСамосвалы");
	Иначе
		Описание = ПолучитьОписаниеИзМакета("ОписаниеШаблонСпецавтомобили");
	КонецЕсли;
КонецПроцедуры

#КонецОбласти


#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура Выбрать(Команда)
	ВыбратьШаблон();
КонецПроцедуры

#КонецОбласти


#Область СлужебныеПроцедурыИФункции

&НаСервере
Функция ПолучитьОписаниеИзМакета(ИмяМакета)
	Возврат РегистрыСведений.уатНормыРасходаГСМ.ПолучитьМакет(ИмяМакета).ПолучитьТекст();
КонецФункции

&НаКлиенте
Процедура ВыбратьШаблон()
	ТекСтрока = Элементы.ШаблоныФормул.ТекущиеДанные;
	Если ТекСтрока = Неопределено Тогда
		Рез = Неопределено;
	Иначе
		Рез = Новый Структура;
		Рез.Вставить("ОбщаяФормула", ТекСтрока.Значение);
		Если НаличиеСпидометра Тогда
			Рез.Вставить("ЛинейнаяНорма", "0.01*[Hs]*[S]*[HL]");
			Рез.Вставить("ЛинейнаяНормаКоэффициент", "[Kсн]+[Kтм]+[Kтс]+[Kур]+[Kнк]");
			Рез.Вставить("ЛинейнаяНормаИспользование", Истина);
		Иначе
			Рез.Вставить("НормаСпециальнаяНаМоточас", "[Ht]*[T]");
			Рез.Вставить("НормаСпециальнаяНаМоточасКоэффициент", "[Kсн]+[Kтм]+[Kтс]+[Kур]+[Kнк]");
			Рез.Вставить("НормаСпециальнаяНаМоточасИспользование", Истина);
		КонецЕсли;
		Рез.Вставить("НормаНаПростойСВклДвигателем", "[Hdt]*[DT]");
		Рез.Вставить("НормаНаПростойСВклДвигателемКоэффициент", "[Kтс]");
		Рез.Вставить("НормаНаПростойСВклДвигателемИспользование", Истина);
		Рез.Вставить("НормаНаЕздку", "[Hhl]*[HL]");
		Рез.Вставить("НормаНаЕздкуКоэффициент", "");
		Рез.Вставить("НормаНаЕздкуИспользование", Истина);
		Рез.Вставить("НормаНаЗапуск", "[Hst]*[ST]");
		Рез.Вставить("НормаНаЗапускКоэффициент", "[Kсн]+[Kтм]");
		Рез.Вставить("НормаНаЗапускИспользование", Истина);
				
		Если ТекСтрока.Представление = "Автобусы" Тогда
			Рез.Вставить("НормаНаОтопитель", "[Hht]*[Tht]");
			Рез.Вставить("НормаНаОтопительКоэффициент", "");
			Рез.Вставить("НормаНаОтопительИспользование", Истина);
		ИначеЕсли ТекСтрока.Представление = "Грузовые автомобили" Тогда
			Рез.Вставить("НормаНаОперацию", "[Hop]*[OP]");
			Рез.Вставить("НормаНаОперациюКоэффициент", "[Kсн]+[Kтм]");
			Рез.Вставить("НормаНаОперациюИспользование", Истина);
			Рез.Вставить("НормаНаОтопитель", "[Hht]*[Tht]");
			Рез.Вставить("НормаНаОтопительКоэффициент", "");
			Рез.Вставить("НормаНаОтопительИспользование", Истина);
			Рез.Вставить("НормаНаИзменениеСобственногоВеса", "0.01*[Hg]*[S]*[Gив]*[HL]");
			Рез.Вставить("НормаНаИзменениеСобственногоВесаКоэффициент", "[Kсн]+[Kтм]+[Kтс]+[Kур]");
			Рез.Вставить("НормаНаИзменениеСобственногоВесаИспользование", Истина);
			Рез.Вставить("НормаНаТранспортнуюРаботу", "0.01*[Hw]*[Sгр]*[Gгр]*[HL]");
			Рез.Вставить("НормаНаТранспортнуюРаботуКоэффициент", "[Kсн]+[Kтм]+[Kтс]+[Kур]");
			Рез.Вставить("НормаНаТранспортнуюРаботуИспользование", Истина);
		ИначеЕсли ТекСтрока.Представление = "Самосвалы" Тогда
			Рез.Вставить("НормаНаОперацию", "[Hop]*[OP]");
			Рез.Вставить("НормаНаОперациюКоэффициент", "[Kсн]+[Kтм]");
			Рез.Вставить("НормаНаОперациюИспользование", Истина);
			Рез.Вставить("НормаНаОтопитель", "[Hht]*[Tht]");
			Рез.Вставить("НормаНаОтопительКоэффициент", "");
			Рез.Вставить("НормаНаОтопительИспользование", Истина);
			Рез.Вставить("НормаНаТранспортнуюРаботу", "0.01*[Hw]*[S]*[GP]*[Q]*[HL]");
			Рез.Вставить("НормаНаТранспортнуюРаботуКоэффициент", "[Kсн]+[Kтм]+[Kтс]+[Kур]");
			Рез.Вставить("НормаНаТранспортнуюРаботуИспользование", Истина);
		ИначеЕсли ТекСтрока.Представление = "Специальные автомобили" Тогда
			Рез.Вставить("НормаНаОперацию", "[Hop]*[OP]");
			Рез.Вставить("НормаНаОперациюКоэффициент", "[Kсн]+[Kтм]");
			Рез.Вставить("НормаНаОперациюИспользование", Истина);
			Рез.Вставить("НормаНаОтопитель", "[Hht]*[Tht]");
			Рез.Вставить("НормаНаОтопительКоэффициент", "");
			Рез.Вставить("НормаНаОтопительИспользование", Истина);
			Рез.Вставить("НормаНаИзменениеСобственногоВеса", "0.01*[Hg]*[S]*[Gив]*[HL]");
			Рез.Вставить("НормаНаИзменениеСобственногоВесаКоэффициент", "[Kсн]+[Kтм]+[Kтс]+[Kур]");
			Рез.Вставить("НормаНаИзменениеСобственногоВесаИспользование", Истина);
			Рез.Вставить("НормаНаТранспортнуюРаботу", "0.01*[Hw]*[Sгр]*[Gгр]*[HL]");
			Рез.Вставить("НормаНаТранспортнуюРаботуКоэффициент", "[Kсн]+[Kтм]+[Kтс]+[Kур]");
			Рез.Вставить("НормаНаТранспортнуюРаботуИспользование", Истина);
			Рез.Вставить("НормаНаСпециальнуюРаботу1", "0.01*[Hсп1]*[Сп1]");
			Рез.Вставить("НормаНаСпециальнуюРаботу1Коэффициент", "[Kсн]+[Kтм]+[Kтс]+[Kур]");
			Рез.Вставить("НормаНаСпециальнуюРаботу1Использование", Истина);
		КонецЕсли;
	КонецЕсли;
		
	Закрыть(Рез);
КонецПроцедуры

#КонецОбласти
